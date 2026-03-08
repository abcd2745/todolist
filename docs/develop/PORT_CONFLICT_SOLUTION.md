# Docker端口冲突问题分析与解决方案

## 🔍 问题场景分析

### 场景1：同一台机器，多个Agent同时工作（主要问题）

```bash
# Agent 1 想启动测试环境
docker-compose --profile agent_1 up
→ 占用端口：8001(backend), 5173(frontend), 5432(db)

# Agent 2 也想启动测试环境（在同一个项目目录）
docker-compose --profile agent_1 up  ← ❌ 端口冲突！
→ 错误：Port 8001 is already allocated
```

**问题**：
- ✅ 不同profile（agent_1 vs agent_2）端口已错开，不冲突
- ❌ **相同profile**同时启动会冲突

---

### 场景2：共享数据库的端口冲突

```yaml
# 当前配置
postgres:
  ports:
    - "5432:5432"  # 主机端口5432被占用
```

**问题**：
- 如果机器上已有其他PostgreSQL占用5432
- 或者其他项目也在使用5432端口

---

## ✅ 解决方案对比

### 方案1：动态端口分配（推荐）

**优势**：
- ✅ 完全避免冲突
- ✅ 灵活可配置
- ✅ 支持多Agent并行

**实现**：

#### 修改docker-compose.yml

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev_password
      POSTGRES_DB: todolist
    ports:
      - "${POSTGRES_PORT:-5432}:5432"  # 可配置
    volumes:
      - postgres_data:/var/lib/postgresql/data

  agent-backend:
    profiles: ["${AGENT_ID:-agent_1}"]
    ports:
      - "${BACKEND_PORT:-8001}:8000"  # 可配置
    environment:
      DATABASE_URL: postgresql://dev:dev_password@postgres:5432/todolist
      DB_SCHEMA: ${DB_SCHEMA:-agent_1}

  agent-frontend:
    profiles: ["${AGENT_ID:-agent_1}"]
    ports:
      - "${FRONTEND_PORT:-5173}:5173"  # 可配置
```

#### 启动脚本

```bash
#!/bin/bash
# scripts/start-agent.sh

AGENT_ID=${1:-agent_1}

# 根据Agent ID分配端口
case $AGENT_ID in
  agent_1)
    BACKEND_PORT=8001
    FRONTEND_PORT=5173
    ;;
  agent_2)
    BACKEND_PORT=8002
    FRONTEND_PORT=5174
    ;;
  agent_3)
    BACKEND_PORT=8003
    FRONTEND_PORT=5175
    ;;
  *)
    echo "Unknown agent: $AGENT_ID"
    exit 1
    ;;
esac

# 启动容器
export AGENT_ID BACKEND_PORT FRONTEND_PORT
docker-compose --profile $AGENT_ID up
```

**使用**：
```bash
# Agent 1
./scripts/start-agent.sh agent_1

# Agent 2（不会冲突）
./scripts/start-agent.sh agent_2
```

---

### 方案2：Docker Compose项目隔离（最简单）

**优势**：
- ✅ 完全隔离，零冲突
- ✅ 无需修改配置
- ✅ 每个Agent独立环境

**实现**：

```bash
# Agent 1 使用独立项目名
docker-compose -p agent1 --profile agent_1 up

# Agent 2 使用独立项目名
docker-compose -p agent2 --profile agent_1 up
```

**原理**：
- `-p agent1` 创建独立的项目空间
- 容器名、网络、volumes都加上前缀
- 端口映射到不同的容器（但主机端口仍然冲突）

**问题**：
- ❌ 主机端口仍然冲突！

**改进方案**：结合环境变量

```bash
# Agent 1
BACKEND_PORT=8001 docker-compose -p agent1 up

# Agent 2
BACKEND_PORT=8002 docker-compose -p agent2 up
```

---

### 方案3：不暴露端口，内部访问（最适合CI/CD）

**优势**：
- ✅ 无端口冲突
- ✅ 安全性更高
- ✅ 适合自动化测试

**实现**：

```yaml
services:
  postgres:
    # 不暴露到主机
    expose:
      - "5432"  # 只在Docker网络内部可访问
    # ports: []  # 移除端口映射

  agent-backend:
    expose:
      - "8000"  # 只在Docker网络内部可访问
    depends_on:
      - postgres

  # 测试容器
  test-runner:
    image: python:3.11
    depends_on:
      - agent-backend
      - postgres
    command: pytest tests/
    networks:
      - todolist-network
```

**访问方式**：
```bash
# 在Docker网络内部访问
docker-compose run test-runner curl http://agent-backend:8000/api

# 或通过容器名访问
docker exec <backend-container> curl http://postgres:5432
```

---

### 方案4：端口范围分配（适合团队协作）

**优势**：
- ✅ 固定规则，易于管理
- ✅ 支持多开发者
- ✅ 清晰的资源分配

**实现**：

#### 团队端口分配表

| 开发者/Agent | Backend | Frontend | Database |
|-------------|---------|----------|----------|
| Developer A | 8001-8010 | 5173-5182 | 5432 |
| Developer B | 8011-8020 | 5183-5192 | 5433 |
| Developer C | 8021-8030 | 5193-5202 | 5434 |
| CI/CD       | 8100+    | 5200+    | 5440+ |

#### 配置文件

```bash
# .env.developer-a
BACKEND_PORT=8001
FRONTEND_PORT=5173
POSTGRES_PORT=5432
AGENT_ID=agent_a

# .env.developer-b
BACKEND_PORT=8011
FRONTEND_PORT=5183
POSTGRES_PORT=5433
AGENT_ID=agent_b
```

#### 启动

```bash
# Developer A
cp .env.developer-a .env
docker-compose up

# Developer B
cp .env.developer-b .env
docker-compose up
```

---

### 方案5：Git Worktree + 独立环境（最彻底）

**优势**：
- ✅ 代码隔离
- ✅ 环境隔离
- ✅ 无任何冲突

**实现**：

```bash
# 主项目目录
cd /projects/todolist

# 为每个Agent创建独立的worktree
git worktree add ../todolist-agent1 -b feature/agent1
git worktree add ../todolist-agent2 -b feature/agent2

# 每个worktree独立启动
cd ../todolist-agent1
./scripts/start-dev.sh  # 端口8001

cd ../todolist-agent2
./scripts/start-dev.sh  # 端口8002
```

---

## 🎯 推荐方案

### 对于不同场景，推荐不同方案：

#### 场景1：单机多Agent测试（推荐方案1）

```yaml
# docker-compose.yml
services:
  agent-backend:
    ports:
      - "${BACKEND_PORT:-8001}:8000"
```

```bash
# 启动Agent 1
BACKEND_PORT=8001 docker-compose --profile agent_1 up -d

# 启动Agent 2（不冲突）
BACKEND_PORT=8002 docker-compose --profile agent_2 up -d
```

---

#### 场景2：团队协作开发（推荐方案4）

```bash
# 每个开发者使用自己的.env文件
cp .env.template .env
# 编辑.env，设置自己的端口范围

docker-compose up
```

---

#### 场景3：CI/CD自动化测试（推荐方案3）

```yaml
# 不暴露端口，完全内部访问
services:
  test-runner:
    depends_on: [backend, postgres]
    command: pytest
```

---

## 📝 实际配置示例

### 完整的动态端口配置

```yaml
# docker-compose.yml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: "${COMPOSE_PROJECT_NAME:-todolist}-db"
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev_password
      POSTGRES_DB: todolist
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - todolist-network

  agent-backend:
    profiles: ["${AGENT_ID:-agent_1}"]
    container_name: "${COMPOSE_PROJECT_NAME:-todolist}-${AGENT_ID:-agent_1}-backend"
    ports:
      - "${BACKEND_PORT:-8001}:8000"
    environment:
      DATABASE_URL: postgresql://dev:dev_password@postgres:5432/todolist
      DB_SCHEMA: ${DB_SCHEMA:-agent_1}
    networks:
      - todolist-network
    depends_on:
      - postgres

  agent-frontend:
    profiles: ["${AGENT_ID:-agent_1}"]
    container_name: "${COMPOSE_PROJECT_NAME:-todolist}-${AGENT_ID:-agent_1}-frontend"
    ports:
      - "${FRONTEND_PORT:-5173}:5173"
    environment:
      VITE_API_URL: http://localhost:${BACKEND_PORT:-8001}
    networks:
      - todolist-network
    depends_on:
      - agent-backend

volumes:
  postgres_data:

networks:
  todolist-network:
```

### 启动脚本

```bash
#!/bin/bash
# scripts/start-agent-env.sh

set -e

AGENT_ID=${1:-agent_1}

# 根据Agent ID分配端口
if [ "$AGENT_ID" == "agent_1" ]; then
  export BACKEND_PORT=8001
  export FRONTEND_PORT=5173
  export POSTGRES_PORT=5432
elif [ "$AGENT_ID" == "agent_2" ]; then
  export BACKEND_PORT=8002
  export FRONTEND_PORT=5174
  export POSTGRES_PORT=5433
elif [ "$AGENT_ID" == "agent_3" ]; then
  export BACKEND_PORT=8003
  export FRONTEND_PORT=5175
  export POSTGRES_PORT=5434
else
  echo "❌ Unknown agent: $AGENT_ID"
  echo "Usage: $0 [agent_1|agent_2|agent_3]"
  exit 1
fi

export AGENT_ID
export COMPOSE_PROJECT_NAME="todolist-${AGENT_ID}"

echo "🚀 启动 ${AGENT_ID} 环境"
echo "  Backend: http://localhost:${BACKEND_PORT}"
echo "  Frontend: http://localhost:${FRONTEND_PORT}"
echo "  Database: localhost:${POSTGRES_PORT}"

docker-compose --profile ${AGENT_ID} up
```

### 使用方式

```bash
# Agent 1
./scripts/start-agent-env.sh agent_1

# Agent 2（同时运行，不冲突）
./scripts/start-agent-env.sh agent_2

# Agent 3
./scripts/start-agent-env.sh agent_3
```

---

## 🔧 解决您当前的问题

### 当前简化版的端口冲突问题

**问题**：当前简化版只有postgres，端口固定5432

**解决方案**：

```yaml
# docker-compose.yml（修改后）
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: "${COMPOSE_PROJECT_NAME:-todolist}-db"
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev_password
      POSTGRES_DB: todolist
    ports:
      - "${POSTGRES_PORT:-5432}:5432"  # 可配置
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### 启动脚本修改

```bash
#!/bin/bash
# scripts/setup-db.sh（修改后）

set -e

# 允许自定义端口
POSTGRES_PORT=${1:-5432}

export COMPOSE_PROJECT_NAME="todolist"
export POSTGRES_PORT

echo "========================================"
echo "  🚀 初始化开发数据库"
echo "========================================"
echo "端口: ${POSTGRES_PORT}"
echo ""

# 启动数据库
docker-compose up -d postgres

# ... 其他步骤
```

### 使用

```bash
# 使用默认端口5432
./scripts/setup-db.sh

# 使用自定义端口（避免冲突）
./scripts/setup-db.sh 5433
```

---

## ✅ 推荐给您的最终方案

**针对您的问题，推荐使用方案1（动态端口）+ 方案4（端口范围分配）的组合**：

1. **修改配置文件支持动态端口**
2. **为每个Agent预设端口范围**
3. **启动时自动分配**

**优势**：
- ✅ 简单易用
- ✅ 完全避免冲突
- ✅ 支持多Agent并行
- ✅ 灵活可扩展

---

**是否需要我实现完整的动态端口配置和启动脚本？**