#!/bin/bash
# =============================================================================
# 简化版数据库初始化脚本 - Phase 1: 最小可用
# =============================================================================
# 目标：5分钟内创建可用数据库环境
# 功能：启动数据库 + 创建Schema
# =============================================================================

set -e

echo "========================================"
echo "  🚀 初始化开发数据库"
echo "========================================"

# 1. 检查Docker
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker未运行，请先启动Docker"
    echo ""
    echo "💡 提示："
    echo "   macOS: 打开Docker Desktop应用"
    echo "   Linux: sudo systemctl start docker"
    exit 1
fi

echo "✅ Docker运行正常"

# 2. 启动数据库
echo "📦 启动数据库容器..."
docker-compose up -d postgres

# 3. 等待就绪
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

# 4. 创建Schema
echo "📝 创建Schema..."
docker exec -i todolist-db psql -U dev -d todolist <<SQL
-- 创建Agent schemas
CREATE SCHEMA IF NOT EXISTS agent_1;
GRANT ALL PRIVILEGES ON SCHEMA agent_1 TO dev;

CREATE SCHEMA IF NOT EXISTS agent_2;
GRANT ALL PRIVILEGES ON SCHEMA agent_2 TO dev;

CREATE SCHEMA IF NOT EXISTS agent_3;
GRANT ALL PRIVILEGES ON SCHEMA agent_3 TO dev;
SQL

echo ""
echo "========================================"
echo "  ✅ 数据库环境就绪！"
echo "========================================"
echo ""
echo "📊 连接信息："
echo "  Host: localhost"
echo "  Port: 5432"
echo "  Database: todolist"
echo "  User: dev"
echo "  Password: dev_password"
echo "  Schemas: agent_1, agent_2, agent_3"
echo ""
echo "🔍 测试连接："
echo "  docker exec -it todolist-db psql -U dev -d todolist"
echo ""
echo "📋 查看Schema："
echo "  docker exec -it todolist-db psql -U dev -d todolist -c '\\dn'"
echo ""