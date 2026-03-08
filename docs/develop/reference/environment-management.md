# 环境管理架构设计

## 概述

本文档描述多Agent开发环境的Docker Compose架构设计，解决Agent领取任务前获得正确开发和测试环境的核心需求。

---

## 1. 架构设计原则

### 1.1 核心需求
- ✅ Agent领取任务前获得可运行的环境
- ✅ 使用Docker Compose管理环境
- ✅ Agent完成后更新环境供其他Agent共享
- ✅ 多Agent并行开发支持

### 1.2 设计目标
- **资源效率**：共享数据库容器，节省内存
- **隔离性**：每个Agent独立schema，无数据冲突
- **管理简便**：统一配置，按需启动
- **环境一致**：所有Agent使用相同环境

---

## 2. 架构方案

### 2.1 推荐方案：混合架构

**架构图**：
```
┌─────────────────────────────────────────────────────────────────────────┐
│                           Docker Network: todolist-dev                  │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                 共享数据库容器（PostgreSQL :5432）                │   │
│  │  schema: agent_1  |  schema: agent_2  |  schema: agent_N         │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│         ┌────────────────────┼────────────────────┐                    │
│         ▼                    ▼                    ▼                     │
│  ┌─────────────┐      ┌─────────────┐      ┌─────────────┐            │
│  │ Agent 1     │      │ Agent 2     │      │ Agent N     │            │
│  │ Backend:8001│      │ Backend:8002│      │ Backend:800N│            │
│  │ Frontend:   │      │ Frontend:   │      │ Frontend:   │            │
│  │   5173      │      │   5174      │      │   5173+N    │            │
│  └─────────────┘      └─────────────┘      └─────────────┘            │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 方案对比

| 方案 | 资源效率 | 隔离性 | 管理复杂度 | 推荐 |
|------|----------|--------|------------|------|
| 共享容器环境 | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | 不推荐 |
| 完全独立容器 | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | 中等 |
| **混合架构（Schema隔离）** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | **推荐** |

### 2.3 关键设计决策

#### 决策1：Schema隔离而非Database隔离

**理由**：
- ✅ 资源效率：共享连接池和缓存
- ✅ 管理简便：统一迁移脚本
- ✅ 数据一致性：容易保持schema一致
- ✅ 性能：共享缓存，性能更好

**对比表**：

| 对比维度 | Schema隔离 | Database隔离 |
|----------|-------------|---------------|
| 资源消耗 | ⭐⭐⭐⭐⭐ 共享连接池 | ⭐⭐ 独立连接池 |
| 管理复杂度 | ⭐⭐⭐⭐⭐ 统一迁移 | ⭐⭐ 多库迁移 |
| 隔离性 | ⭐⭐⭐⭐ 足够开发用 | ⭐⭐⭐⭐⭐ 完全隔离 |
| 适用场景 | 内部开发团队 | 多租户SaaS |

#### 决策2：Volume设计策略

| Volume类型 | 用途 | 配置 |
|------------|------|------|
| `postgres_data` | 数据库持久化 | 命名volume（共享） |
| `agentX_backend_venv` | Python虚拟环境 | 命名volume（独立） |
| `agentX_frontend_node` | Node modules | 命名volume（独立） |
| `./data/tasks/agentX` | 任务文件存储 | Bind mount（独立） |
| `./backend:/app/code:cached` | 代码挂载 | Bind mount（只读+cached） |

---

## 3. Docker Compose配置

### 3.1 核心配置文件

**文件位置**：`docker-compose.yml`

**关键配置**：

```yaml
version: '3.8'

services:
  # 共享数据库
  postgres:
    image: postgres:15-alpine
    container_name: todolist-db
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev_password
      POSTGRES_DB: todolist
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/init-schemas.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - todolist-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U dev"]
      interval: 5s
      timeout: 5s
      retries: 5

  # Agent 1 后端
  agent1-backend:
    profiles: ["agent_1"]
    build:
      context: ./backend
      dockerfile: Dockerfile.dev
    container_name: todolist-agent1-backend
    environment:
      DATABASE_URL: postgresql://dev:dev_password@postgres:5432/todolist
      DB_SCHEMA: agent_1
      PYTHONUNBUFFERED: 1
    ports:
      - "8001:8000"
    volumes:
      - ./backend:/app/code:cached
      - agent1_backend_venv:/app/venv
      - ./data/tasks/agent1:/app/data/tasks
    working_dir: /app/code
    command: uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - todolist-network

  # Agent 1 前端
  agent1-frontend:
    profiles: ["agent_1"]
    build:
      context: ./frontend
      dockerfile: Dockerfile.dev
    container_name: todolist-agent1-frontend
    environment:
      VITE_API_URL: http://localhost:8001
      NODE_ENV: development
    ports:
      - "5173:5173"
    volumes:
      - ./frontend:/app/code:cached
      - agent1_frontend_node:/app/code/node_modules
    working_dir: /app/code
    command: pnpm run dev --host 0.0.0.0
    networks:
      - todolist-network

volumes:
  postgres_data:
    driver: local
  agent1_backend_venv:
    driver: local
  agent1_frontend_node:
    driver: local

networks:
  todolist-network:
    driver: bridge
```

### 3.2 Profile启动机制

**按需启动Agent环境**：

```bash
# 启动Agent 1环境
docker-compose --profile agent_1 up

# 启动Agent 2环境
docker-compose --profile agent_2 up

# 启动多个Agent环境
docker-compose --profile agent_1 --profile agent_2 up
```

**优势**：
- ✅ 资源按需分配
- ✅ 避免端口冲突
- ✅ 灵活扩展

---

## 4. 环境初始化流程

### 4.1 完整流程图

```
Agent领取任务
    │
    ├─→ Step 1: 环境检查
    │   ├─ 检查Docker运行状态
    │   ├─ 检查数据库容器状态
    │   ├─ 检查Schema是否存在
    │   └─ 检查依赖安装状态
    │
    ├─→ Step 2: 环境初始化（如需要）
    │   ├─ 启动数据库容器
    │   ├─ 创建Agent专属schema
    │   ├─ 运行数据库迁移
    │   ├─ 初始化种子数据
    │   └─ 创建任务存储目录
    │
    ├─→ Step 3: 启动开发环境
    │   └─ docker-compose --profile agent_X up
    │
    └─→ Step 4: 开始开发
```

### 4.2 环境检查脚本

**文件位置**：`scripts/check-env.sh`

**主要功能**：
1. 检查Docker是否运行
2. 检查数据库容器状态
3. 检查Schema是否存在
4. 检查依赖是否安装

### 4.3 环境初始化脚本

**文件位置**：`scripts/init-agent-env.sh`

**主要功能**：
1. 启动数据库容器
2. 创建Agent专属schema
3. 运行数据库迁移
4. 初始化种子数据
5. 创建任务存储目录

---

## 5. 数据库Schema管理

### 5.1 Schema结构

```
PostgreSQL: todolist
│
├── schema: public (共享表：配置、字典等)
│
├── schema: agent_1 (Agent 1 专属)
│   ├── users
│   ├── tasks
│   ├── achievements
│   └── user_behavior_logs
│
├── schema: agent_2 (Agent 2 专属)
│   ├── users
│   ├── tasks
│   ├── achievements
│   └── user_behavior_logs
│
└── schema: agent_N ...
```

### 5.2 SQLAlchemy多Schema支持

**配置方式**：

```python
# backend/app/db/session.py
from sqlalchemy import create_engine, event
from sqlalchemy.orm import sessionmaker
import os

DATABASE_URL = os.getenv("DATABASE_URL")
DB_SCHEMA = os.getenv("DB_SCHEMA", "public")

engine = create_engine(DATABASE_URL)

@event.listens_for(engine, "begin")
def do_begin(conn):
    conn.exec_driver_sql(f"SET search_path TO {DB_SCHEMA}, public")

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
```

### 5.3 Alembic多Schema迁移

**配置方式**：

```python
# alembic/env.py
import os

DB_SCHEMA = os.getenv("DB_SCHEMA", "public")

def run_migrations_online():
    # ...
    with connectable.connect() as connection:
        connection.execute(f"SET search_path TO {DB_SCHEMA}, public")

        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            version_table=f"{DB_SCHEMA}.alembic_version",
        )
```

---

## 6. 代码同步机制

### 6.1 同步策略

**推荐方案：Volume实时同步 + Git Pull**

**Volume挂载**：
```yaml
volumes:
  - ./backend:/app/code:cached  # 实时同步
```

**Git同步流程**：
```
Agent启动 → git pull → 获取最新代码
    ↓
开发阶段 → 文件实时同步（Volume）
    ↓
任务完成 → git push → 更新远程仓库
    ↓
其他Agent → git pull → 获取更新
```

### 6.2 环境更新机制

**Post-merge Hook自动更新**：

```bash
#!/bin/bash
# .git/hooks/post-merge

# 检查依赖变化
if git diff HEAD~1 HEAD -- backend/pyproject.toml | grep -q '^\+'; then
    echo "检测到依赖变化，更新Python环境..."
    cd backend
    poetry install
fi

# 检查数据库迁移
if git diff HEAD~1 HEAD -- backend/alembic/versions/ | grep -q '^\+'; then
    echo "检测到新的数据库迁移..."
    export DB_SCHEMA=${DB_SCHEMA:-agent_1}
    cd backend
    alembic upgrade head
fi
```

---

## 7. 快速启动命令

```bash
# =============================================================================
# 环境管理命令速查
# =============================================================================

# 1. 初始化Agent环境
./scripts/init-agent-env.sh agent_1

# 2. 启动开发环境
docker-compose --profile agent_1 up

# 3. 后台运行
docker-compose --profile agent_1 up -d

# 4. 查看日志
docker-compose --profile agent_1 logs -f

# 5. 停止环境
docker-compose --profile agent_1 down

# 6. 重建容器
docker-compose --profile agent_1 up --build

# 7. 清理数据（危险！）
docker-compose --profile agent_1 down -v

# 8. 数据库操作
docker exec -it todolist-db psql -U dev -d todolist

# 9. 运行迁移
docker-compose run --rm -e DB_SCHEMA=agent_1 agent1-backend alembic upgrade head

# 10. 运行测试
docker-compose run --rm agent1-backend pytest tests/ -v
```

---

## 8. 故障排查

### 8.1 常见问题

**问题1：端口冲突**
```bash
# 错误信息
Error: port is already allocated

# 解决方案
# 修改docker-compose.yml中的端口映射
ports:
  - "8002:8000"  # 改为其他端口
```

**问题2：Schema不存在**
```bash
# 错误信息
relation "agent_1.users" does not exist

# 解决方案
./scripts/init-agent-env.sh agent_1
```

**问题3：数据库连接失败**
```bash
# 错误信息
could not connect to server

# 解决方案
# 1. 检查容器状态
docker ps | grep todolist-db

# 2. 重启数据库
docker-compose restart postgres

# 3. 查看日志
docker-compose logs postgres
```

---

## 9. 最佳实践

### 9.1 环境管理最佳实践

1. **定期同步代码**
   ```bash
   # 每天开始工作前
   git pull origin main
   ```

2. **定期更新环境**
   ```bash
   # PR合并后自动运行
   # 或手动运行
   ./scripts/init-agent-env.sh agent_1 --update
   ```

3. **清理旧数据**
   ```bash
   # 定期清理测试数据
   docker exec todolist-db psql -U dev -d todolist -c "TRUNCATE agent_1.tasks CASCADE"
   ```

### 9.2 开发最佳实践

1. **使用环境变量**
   ```bash
   # .env文件
   DB_SCHEMA=agent_1
   DATABASE_URL=postgresql://dev:dev_password@postgres:5432/todolist
   ```

2. **容器内调试**
   ```bash
   # 进入后端容器
   docker exec -it todolist-agent1-backend bash

   # 进入前端容器
   docker exec -it todolist-agent1-frontend sh
   ```

3. **查看容器日志**
   ```bash
   # 实时查看日志
   docker-compose logs -f agent1-backend

   # 查看最近100行
   docker-compose logs --tail=100 agent1-backend
   ```

---

## 10. 参考资料

- [Docker Compose官方文档](https://docs.docker.com/compose/)
- [PostgreSQL Schema管理](https://www.postgresql.org/docs/current/ddl-schemas.html)
- [SQLAlchemy多Schema支持](https://docs.sqlalchemy.org/)
- [Alembic迁移最佳实践](https://alembic.sqlalchemy.org/en/latest/)

---

**文档编写人**: Claude Code
**编写日期**: 2026-03-08
**最后更新**: 2026-03-08