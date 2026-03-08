# 极简开发工作流程

## 🎯 核心原则

**一个数据库，多个Schema，按需清理**

---

## 🚀 快速开始

### 场景1：Agent领取任务

```bash
# 1. 创建专属环境
./scripts/agent-env.sh agent_1 create

# 输出：
# ========================================
#   🚀 创建Agent环境: agent_1
# ========================================
# ✅ Agent环境就绪！
#
# 📊 Schema: agent_1
# 🔗 连接信息：
#   Host: localhost:5432
#   Database: todolist
#   Schema: agent_1
```

### 场景2：开始开发

```bash
# 连接数据库
docker exec -it todolist-db psql -U dev -d todolist

# 在psql中切换到agent_1 schema
SET search_path TO agent_1;

# 创建表
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

# 插入数据
INSERT INTO users (username, email) VALUES ('alice', 'alice@example.com');

# 查询
SELECT * FROM users;
```

### 场景3：测试完成，清理环境

```bash
# 清理Schema（删除所有表和数据）
./scripts/agent-env.sh agent_1 clean

# 输出：
# 确认删除Schema 'agent_1'？(y/N): y
# ✅ Schema已删除
```

---

## 📋 完整工作流程

```
┌─────────────────────────────────────────────────────────┐
│                   Agent工作流程                          │
└─────────────────────────────────────────────────────────┘

1️⃣ 领取任务
   ↓
2️⃣ 创建环境
   ./scripts/agent-env.sh agent_X create
   ↓
3️⃣ 开发编码
   - 编写代码
   - 配置DB_SCHEMA=agent_X
   - 运行本地测试
   ↓
4️⃣ 提交代码
   - Pre-commit检查
   - 测试通过
   - Git提交
   ↓
5️⃣ 清理环境（可选）
   ./scripts/agent-env.sh agent_X clean
```

---

## 💡 使用示例

### 示例1：多个Agent同时工作

```bash
# Agent 1
./scripts/agent-env.sh agent_1 create
# 使用agent_1 schema开发...

# Agent 2（同时进行，无冲突）
./scripts/agent-env.sh agent_2 create
# 使用agent_2 schema开发...

# Agent 3
./scripts/agent-env.sh agent_3 create
# 使用agent_3 schema开发...

# 查看所有schema
docker exec -it todolist-db psql -U dev -d todolist -c "\dn"

# 输出：
#   Name     | Owner
# -----------+-------
#  agent_1   | dev
#  agent_2   | dev
#  agent_3   | dev
#  public    | dev
```

### 示例2：重置环境

```bash
# 测试失败，想重新开始
./scripts/agent-env.sh agent_1 reset

# 输出：
# 🔄 重置Agent环境: agent_1
# 确认删除Schema 'agent_1'？(y/N): y
# ✅ Schema已删除
# ✅ Agent环境就绪！
```

---

## 🔧 配置说明

### 应用配置（后端）

```python
# backend/app/db/session.py
import os
from sqlalchemy import create_engine, event
from sqlalchemy.orm import sessionmaker

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://dev:dev_password@localhost:5432/todolist")
DB_SCHEMA = os.getenv("DB_SCHEMA", "public")

engine = create_engine(DATABASE_URL)

# 自动切换Schema
@event.listens_for(engine, "begin")
def do_begin(conn):
    conn.exec_driver_sql(f"SET search_path TO {DB_SCHEMA}, public")

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
```

### 环境变量

```bash
# Agent 1
export DB_SCHEMA=agent_1
export DATABASE_URL=postgresql://dev:dev_password@localhost:5432/todolist

# Agent 2
export DB_SCHEMA=agent_2
export DATABASE_URL=postgresql://dev:dev_password@localhost:5432/todolist
```

---

## 🎯 测试场景

### 单元测试

```bash
# 运行测试时指定Schema
DB_SCHEMA=agent_1 pytest tests/unit

# 或创建测试专用Schema
./scripts/agent-env.sh test_agent_1 create
DB_SCHEMA=test_agent_1 pytest tests/
./scripts/agent-env.sh test_agent_1 clean
```

### 集成测试

```bash
# CI/CD环境
./scripts/agent-env.sh ci_test create
DB_SCHEMA=ci_test pytest tests/integration
./scripts/agent-env.sh ci_test clean
```

---

## 📊 对比：优化前 vs 优化后

| 维度 | 优化前 | 优化后 |
|------|--------|--------|
| **容器数量** | 每个Agent一套容器 | 只需1个数据库容器 |
| **端口管理** | 需要协调端口 | 固定端口5432 |
| **资源消耗** | 高（多容器） | 低（单容器） |
| **启动时间** | 慢 | 快 |
| **清理难度** | 复杂 | 简单（删除Schema） |
| **并发支持** | 需要配置 | 天然支持 |

---

## 🚫 注意事项

### 1. Schema命名规范

**推荐命名**：
```
agent_{id}       # Agent开发环境
test_{id}        # 测试环境
ci_{id}          # CI/CD环境
```

**避免**：
```
public           # 系统保留
information_schema # 系统保留
pg_*             # PostgreSQL系统表
```

### 2. 数据隔离

```sql
-- ✅ 正确：在正确的Schema中创建表
SET search_path TO agent_1;
CREATE TABLE users (...);

-- ❌ 错误：忘记切换Schema
CREATE TABLE users (...);  -- 创建在public schema
```

### 3. 清理时机

**推荐清理时机**：
- ✅ 测试完成后
- ✅ 任务完成后
- ✅ 不再需要时

**不要过早清理**：
- ❌ 代码还没提交
- ❌ 其他Agent可能需要参考

---

## 📝 实用技巧

### 查看Schema使用情况

```sql
-- 查看所有Schema
\dn

-- 查看Schema中的表
SET search_path TO agent_1;
\dt

-- 查看Schema大小
SELECT
    schemaname,
    pg_size_pretty(SUM(pg_total_relation_size(schemaname || '.' || tablename))::bigint) AS size
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
GROUP BY schemaname;
```

### 批量清理

```bash
# 清理所有agent_*开头的Schema
for schema in $(docker exec -i todolist-db psql -U dev -d todolist -t -c "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'agent_%';"); do
    echo "清理: $schema"
    docker exec -i todolist-db psql -U dev -d todolist -c "DROP SCHEMA IF EXISTS $schema CASCADE;"
done
```

---

## 🎉 总结

### 核心优势

1. **极简** - 一个容器，固定端口
2. **无冲突** - Schema天然隔离
3. **高效** - 共享资源，快速启动
4. **易用** - 简单命令，清晰流程
5. **灵活** - 按需创建，随时清理

### 核心命令

```bash
# 创建环境
./scripts/agent-env.sh agent_1 create

# 开发...

# 清理环境
./scripts/agent-env.sh agent_1 clean
```

---

**创建日期**: 2026-03-08
**状态**: ✅ 可立即使用
**适用场景**: 所有开发测试场景