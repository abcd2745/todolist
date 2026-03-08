# 开发环境设置指南

## 快速开始（5分钟）

### 第一步：初始化数据库

```bash
# 运行初始化脚本
./scripts/setup-db.sh

# 预期输出：
# ========================================
#   🚀 初始化开发数据库
# ========================================
# ✅ Docker运行正常
# 📦 启动数据库容器...
# ✅ 数据库就绪
# 📝 创建Schema...
# ========================================
#   ✅ 数据库环境就绪！
# ========================================
```

### 第二步：验证环境

```bash
# 查看Schema
docker exec -it todolist-db psql -U dev -d todolist -c "\dn"

# 预期输出：
#  Name     | Owner
# ----------+-------
#  agent_1  | dev
#  agent_2  | dev
#  agent_3  | dev
#  public   | dev
```

### 第三步：测试SQL

```bash
# 测试创建表
docker exec -it todolist-db psql -U dev -d todolist <<SQL
SET search_path TO agent_1;
CREATE TABLE test_users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);
INSERT INTO test_users (name) VALUES ('Alice'), ('Bob');
SELECT * FROM test_users;
SQL
```

---

## 完整示例

### 场景：Agent 1 创建用户表

```bash
docker exec -it todolist-db psql -U dev -d todolist <<SQL
-- 切换到agent_1 schema
SET search_path TO agent_1;

-- 创建用户表
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    xp INT DEFAULT 0,
    level INT DEFAULT 1,
    streak_days INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 插入测试数据
INSERT INTO users (username, email, password_hash)
VALUES ('test_user', 'test@example.com', 'hashed_password');

-- 查询
SELECT * FROM users;
SQL
```

---

## 下一步

完成数据库环境后，可以进行：

### Phase 2: 项目初始化

```bash
# 1. 初始化backend
cd backend
poetry init
poetry add fastapi uvicorn sqlalchemy alembic pytest

# 2. 初始化frontend
cd ../frontend
npm create vite@latest . -- --template vue-ts
npm install

# 3. 配置Docker容器
# 创建Dockerfile.dev
# 更新docker-compose.yml添加应用容器
```

---

## 常见问题

### Q1: 如何停止数据库？

```bash
docker-compose down
```

### Q2: 如何重置数据库？

```bash
# 停止并删除数据
docker-compose down -v

# 重新初始化
./scripts/setup-db.sh
```

### Q3: 如何连接数据库客户端？

**DBeaver**:
- Host: localhost
- Port: 5432
- Database: todolist
- Username: dev
- Password: dev_password

**pgAdmin**:
```bash
docker run -d \
  -p 5050:80 \
  -e PGADMIN_DEFAULT_EMAIL=admin@admin.com \
  -e PGADMIN_DEFAULT_PASSWORD=admin \
  dpage/pgadmin4
# 访问 http://localhost:5050
```

---

## 文件说明

```
.
├── docker-compose.yml      # 简化版，仅数据库
├── scripts/
│   └── setup-db.sh         # 简化版，仅Schema创建
└── docs/develop/
    ├── README-SIMPLE.md    # 本文件（快速开始）
    └── reference/          # 详细参考文档
```

---

**创建日期**: 2026-03-08
**状态**: ✅ 可立即执行
**预计耗时**: 5分钟