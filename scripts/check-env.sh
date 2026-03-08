#!/bin/bash
# =============================================================================
# 环境检查脚本
# =============================================================================
# 功能：检查开发环境是否就绪
# 用法：./scripts/check-env.sh <agent_id>
# 示例：./scripts/check-env.sh agent_1
# =============================================================================

set -e

# 参数检查
if [ -z "$1" ]; then
    echo "❌ 错误：缺少agent_id参数"
    echo ""
    echo "用法：$0 <agent_id>"
    echo "示例：$0 agent_1"
    exit 1
fi

AGENT_ID=$1
SCHEMA_NAME=$AGENT_ID
DB_USER="dev"
DB_NAME="todolist"
CONTAINER_NAME="todolist-db"

echo "========================================"
echo "  🔍 环境检查：$AGENT_ID"
echo "========================================"
echo ""

# 1. Docker检查
echo "📋 检查Docker运行状态..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker未运行"
    echo ""
    echo "💡 提示：请启动Docker"
    echo "   macOS: 打开Docker Desktop应用"
    echo "   Linux: sudo systemctl start docker"
    exit 1
fi
echo "✅ Docker运行正常"
echo ""

# 2. 数据库容器检查
echo "📋 检查数据库容器状态..."
if ! docker ps | grep -q $CONTAINER_NAME; then
    echo "⚠️  数据库容器未运行"
    echo ""
    echo "💡 提示：运行以下命令启动容器"
    echo "   docker-compose up -d postgres"
else
    echo "✅ 数据库容器运行正常"
fi
echo ""

# 3. Schema检查
echo "📋 检查数据库Schema..."
if docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "\dn $SCHEMA_NAME" 2>/dev/null | grep -q $SCHEMA_NAME; then
    echo "✅ Schema '$SCHEMA_NAME' 存在"
else
    echo "⚠️  Schema '$SCHEMA_NAME' 不存在，需要初始化"
fi
echo ""

# 4. 依赖检查
echo "📋 检查依赖安装状态..."
if [ -d "backend/venv" ] || [ -d "backend/.venv" ]; then
    echo "✅ Python虚拟环境存在"
else
    echo "⚠️  Python虚拟环境不存在"
fi

if [ -d "frontend/node_modules" ]; then
    echo "✅ Node modules存在"
else
    echo "⚠️  Node modules不存在"
fi
echo ""

# 5. 任务目录检查
echo "📋 检查任务存储目录..."
if [ -d "data/tasks/$AGENT_ID" ]; then
    echo "✅ 任务目录存在: data/tasks/$AGENT_ID"
else
    echo "⚠️  任务目录不存在"
fi
echo ""

echo "========================================"
echo "  ✅ 环境检查完成"
echo "========================================"
echo ""

# 返回状态
if docker ps | grep -q $CONTAINER_NAME && \
   docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "\dn $SCHEMA_NAME" 2>/dev/null | grep -q $SCHEMA_NAME; then
    echo "🎉 环境就绪，可以开始开发"
    exit 0
else
    echo "⚠️  环境需要初始化"
    echo ""
    echo "💡 提示：运行以下命令初始化环境"
    echo "   ./scripts/init-agent-env.sh $AGENT_ID"
    exit 1
fi