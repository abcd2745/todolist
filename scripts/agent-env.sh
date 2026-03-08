# 极简方案：单数据库 + Schema隔离

## 🎯 核心思路

**一个数据库，多个Schema，按需清理**

```
单个PostgreSQL (端口5432)
├── schema: public      (系统表)
├── schema: agent_1     (Agent 1专属)
├── schema: agent_2     (Agent 2专属)
└── schema: agent_N     (Agent N专属)
```

---

## ✅ 方案优势

| 优势 | 说明 |
|------|------|
| **极简** | 只需启动一个数据库容器 |
| **无冲突** | 所有人连接同一个端口5432 |
| **资源高效** | 共享数据库实例，节省内存 |
| **易于清理** | 删除schema即可重置环境 |
| **零配置** | Agent之间无需协调端口 |

---

## 🚀 实施方案

### 1. 数据库配置（极简）

```yaml
# docker-compose.yml
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
      - "5432:5432"  # 固定端口，所有人共享
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U dev"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

---

### 2. Agent环境管理脚本

```bash
#!/bin/bash
# scripts/agent-env.sh - Agent环境管理（极简版）

set -e

AGENT_ID=${1:-agent_1}
ACTION=${2:-create}  # create | clean | reset

DB_CONTAINER="todolist-db"
DB_USER="dev"
DB_NAME="todolist"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

create_schema() {
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  🚀 创建Agent环境: ${AGENT_ID}${NC}"
    echo -e "${GREEN}========================================${NC}"

    # 检查数据库容器
    if ! docker ps | grep -q $DB_CONTAINER; then
        echo -e "${YELLOW}📦 启动数据库容器...${NC}"
        docker-compose up -d postgres
        sleep 5
    fi

    # 创建Schema
    echo -e "${GREEN}📝 创建Schema: ${AGENT_ID}${NC}"
    docker exec -i $DB_CONTAINER psql -U $DB_USER -d $DB_NAME <<SQL
-- 创建Schema
CREATE SCHEMA IF NOT EXISTS ${AGENT_ID};

-- 授权
GRANT ALL PRIVILEGES ON SCHEMA ${AGENT_ID} TO ${DB_USER};
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ${AGENT_ID} TO ${DB_USER};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA ${AGENT_ID} TO ${DB_USER};

-- 设置默认权限
ALTER DEFAULT PRIVILEGES IN SCHEMA ${AGENT_ID}
    GRANT ALL ON TABLES TO ${DB_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA ${AGENT_ID}
    GRANT ALL ON SEQUENCES TO ${DB_USER};

-- 设置search_path（可选）
ALTER USER ${DB_USER} SET search_path TO ${AGENT_ID}, public;
SQL

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  ✅ Agent环境就绪！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "📊 Schema: ${YELLOW}${AGENT_ID}${NC}"
    echo ""
    echo -e "🔗 连接信息："
    echo "  Host: localhost:5432"
    echo "  Database: todolist"
    echo "  User: dev"
    echo "  Password: dev_password"
    echo ""
    echo -e "📝 使用方式："
    echo "  # 在SQL中切换Schema"
    echo "  SET search_path TO ${AGENT_ID};"
    echo ""
    echo "  # 或在代码中指定"
    echo "  DATABASE_URL=postgresql://dev:dev_password@localhost:5432/todolist"
    echo "  DB_SCHEMA=${AGENT_ID}"
    echo ""
}

clean_schema() {
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}  🧹 清理Agent环境: ${AGENT_ID}${NC}"
    echo -e "${YELLOW}========================================${NC}"

    # 确认删除
    read -p "确认删除Schema '${AGENT_ID}'？(y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "已取消"
        exit 0
    fi

    # 删除Schema
    echo -e "${YELLOW}🗑️  删除Schema: ${AGENT_ID}${NC}"
    docker exec -i $DB_CONTAINER psql -U $DB_USER -d $DB_NAME <<SQL
-- 删除Schema（包含所有表和数据）
DROP SCHEMA IF EXISTS ${AGENT_ID} CASCADE;
SQL

    echo ""
    echo -e "${GREEN}✅ Schema已删除${NC}"
    echo ""
}

reset_schema() {
    echo -e "${YELLOW}🔄 重置Agent环境: ${AGENT_ID}${NC}"
    clean_schema
    echo ""
    create_schema
}

# 主逻辑
case $ACTION in
    create)
        create_schema
        ;;
    clean)
        clean_schema
        ;;
    reset)
        reset_schema
        ;;
    *)
        echo "用法: $0 <agent_id> <action>"
        echo ""
        echo "Actions:"
        echo "  create - 创建Schema"
        echo "  clean  - 删除Schema"
        echo "  reset  - 重置Schema（删除后重建）"
        echo ""
        echo "示例:"
        echo "  $0 agent_1 create  # 创建agent_1环境"
        echo "  $0 agent_1 clean   # 清理agent_1环境"
        echo "  $0 agent_1 reset   # 重置agent_1环境"
        exit 1
        ;;
esac