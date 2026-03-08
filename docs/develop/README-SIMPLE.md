# 简化版开发环境 - 快速指南

## 🎯 设计原则

**从0到1，渐进式构建**

```
Phase 1: 数据库环境 (当前) → ✅ 立即可用
  ↓
Phase 2: 项目初始化 (下一步) → 初始化backend/frontend
  ↓
Phase 3: 开发工具 (后续) → 添加测试、格式化
  ↓
Phase 4: 多Agent支持 (按需) → Schema隔离、多环境
```

---

## ✅ Phase 1: 最小可用环境（当前实施）

### 目标
- 5分钟内启动数据库
- 可以立即测试SQL语句
- 无任何依赖问题

### 实施步骤

#### 1. 创建最简docker-compose.yml

```bash
# 备份原文件
mv docker-compose.yml docker-compose.yml.backup

# 创建简化版
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
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

volumes:
  postgres_data:
EOF
```

#### 2. 创建简化脚本

```bash
# 备份原文件
mv scripts/init-agent-env.sh scripts/init-agent-env.sh.backup

# 创建简化版
cat > scripts/setup-db.sh << 'EOF'
#!/bin/bash
set -e

echo "========================================"
echo "  🚀 初始化开发数据库"
echo "========================================"

# 检查Docker
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker未运行，请先启动Docker"
    exit 1
fi

# 启动数据库
echo "📦 启动数据库容器..."
docker-compose up -d postgres

# 等待就绪
echo "⏳ 等待数据库启动..."
sleep 5

for i in {1..10}; do
    if docker exec todolist-db pg_isready -U dev > /dev/null 2>&1; then
        echo "✅ 数据库就绪"
        break
    fi
    echo "等待中... ($i/10)"
    sleep 2
done

# 创建Schema
echo "📝 创建Schema..."
docker exec -i todolist-db psql -U dev -d todolist <<SQL
CREATE SCHEMA IF NOT EXISTS agent_1;
GRANT ALL PRIVILEGES ON SCHEMA agent_1 TO dev;

CREATE SCHEMA IF NOT EXISTS agent_2;
GRANT ALL PRIVILEGES ON SCHEMA agent_2 TO dev;
SQL

echo ""
echo "========================================"
echo "  ✅ 数据库环境就绪！"
echo "========================================"
echo ""
echo "连接信息："
echo "  Host: localhost"
echo "  Port: 5432"
echo "  Database: todolist"
echo "  User: dev"
echo "  Password: dev_password"
echo "  Schemas: agent_1, agent_2"
echo ""
echo "测试连接："
echo "  docker exec -it todolist-db psql -U dev -d todolist"
echo ""

EOF

chmod +x scripts/setup-db.sh
```

#### 3. 运行测试

```bash
# 运行脚本
./scripts/setup-db.sh

# 验证数据库
docker exec -it todolist-db psql -U dev -d todolist -c "\dn"

# 预期输出：
#  List of schemas
#  Name    | Owner
# ---------+-------
#  agent_1 | dev
#  agent_2 | dev
#  public  | dev
```

### 成功标准
- ✅ 数据库容器正常运行
- ✅ 可以连接数据库
- ✅ Schema创建成功
- ✅ 总耗时 < 5分钟

---

## 📁 文件结构（Phase 1）

```
.
├── docker-compose.yml          # 简化版（30行）
├── scripts/
│   └── setup-db.sh             # 简化版（40行）
└── docs/develop/
    ├── README-SIMPLE.md        # 本文件
    └── reference/              # 详细参考文档（可选）
        ├── environment-management.md
        └── quality-gate.md
```

---

## 🚫 暂时移除的内容（保留备份）

以下内容**过度设计**，暂时移除，保留备份：

```
备份文件：
├── docker-compose.yml.backup              # 完整版配置
├── scripts/init-agent-env.sh.backup      # 完整版脚本
├── .pre-commit-config.yaml.backup        # Pre-commit配置
└── .git/hooks/pre-commit.backup          # Git hook

移除原因：
1. 项目未初始化，缺少backend/frontend目录
2. 缺少Dockerfile，无法构建应用容器
3. 缺少测试框架，pre-commit无法运行
```

---

## 📋 下一步计划（Phase 2）

### 等项目初始化后

**前置条件**：
```bash
# 初始化backend项目
cd backend
poetry init
poetry add fastapi uvicorn sqlalchemy alembic pytest

# 初始化frontend项目
cd ../frontend
npm create vite@latest . -- --template vue-ts
npm install
```

**然后执行**：
1. 创建 `backend/Dockerfile.dev`
2. 创建 `frontend/Dockerfile.dev`
3. 更新 `docker-compose.yml` 添加应用容器
4. 配置 pre-commit hooks
5. 添加测试框架

---

## 🎯 优化对比

| 项目 | 原设计 | 简化版 | 改进 |
|------|--------|--------|------|
| docker-compose.yml | 200行，多Agent | 30行，仅数据库 | ✅ 可立即运行 |
| 初始化脚本 | 150行，含迁移 | 40行，仅Schema | ✅ 无依赖问题 |
| Pre-commit | 完整CI/CD | 暂不配置 | ✅ 避免过早配置 |
| 文档 | 1500+行 | 200行核心 | ✅ 快速理解 |
| 可执行性 | ❌ 无法运行 | ✅ 立即可用 | ✅ 解决实际问题 |

---

## 💡 核心优势

### 1. 立即可用
```bash
./scripts/setup-db.sh
# 5分钟内完成，无任何错误
```

### 2. 无依赖问题
- 不需要backend/frontend目录
- 不需要Poetry/npm
- 只需要Docker

### 3. 清晰的扩展路径
```
Phase 1 (当前) → 数据库
Phase 2 (下一步) → 项目初始化
Phase 3 (后续) → 开发工具
Phase 4 (按需) → 多Agent支持
```

---

## 📞 验证清单

运行以下命令验证环境：

```bash
# 1. 检查文件存在
ls -la docker-compose.yml scripts/setup-db.sh

# 2. 运行初始化
./scripts/setup-db.sh

# 3. 检查容器
docker ps | grep todolist-db

# 4. 测试连接
docker exec -it todolist-db psql -U dev -d todolist -c "\dn"

# 5. 测试SQL
docker exec -it todolist-db psql -U dev -d todolist <<SQL
SET search_path TO agent_1;
CREATE TABLE test (id INT PRIMARY KEY);
INSERT INTO test VALUES (1);
SELECT * FROM test;
SQL
```

---

**创建日期**: 2026-03-08
**状态**: ✅ 可立即执行
**预计耗时**: 5分钟