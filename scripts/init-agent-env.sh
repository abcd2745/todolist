#!/bin/bash
# =============================================================================
# 环境初始化脚本
# =============================================================================
# 功能：为开发Agent初始化完整的开发环境
# 用法：./scripts/init-agent-env.sh <agent_id>
# 示例：./scripts/init-agent-env.sh agent_1
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
DB_PASSWORD="dev_password"
DB_NAME="todolist"
CONTAINER_NAME="todolist-db"

echo "========================================"
echo "  🚀 初始化Agent环境：$AGENT_ID"
echo "========================================"
echo ""

# 1. 检查Docker
echo "📋 Step 1: 检查Docker运行状态..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker未运行"
    echo ""
    echo "💡 提示：请启动Docker"
    exit 1
fi
echo "✅ Docker运行正常"
echo ""

# 2. 启动数据库容器
echo "📋 Step 2: 启动数据库容器..."
if ! docker ps | grep -q $CONTAINER_NAME; then
    echo "正在启动数据库容器..."
    docker-compose up -d postgres

    echo "等待数据库就绪..."
    sleep 5

    # 健康检查
    for i in {1..10}; do
        if docker exec $CONTAINER_NAME pg_isready -U $DB_USER > /dev/null 2>&1; then
            echo "✅ 数据库容器启动成功"
            break
        fi
        echo "等待数据库启动... ($i/10)"
        sleep 2
    done
else
    echo "✅ 数据库容器已在运行"
fi
echo ""

# 3. 创建Schema
echo "📋 Step 3: 创建数据库Schema..."
echo "Schema名称: $SCHEMA_NAME"

docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME <<EOF
-- 创建Schema（如果不存在）
CREATE SCHEMA IF NOT EXISTS $SCHEMA_NAME;

-- 授权
GRANT ALL PRIVILEGES ON SCHEMA $SCHEMA_NAME TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA $SCHEMA_NAME TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA $SCHEMA_NAME TO $DB_USER;

-- 设置默认权限
ALTER DEFAULT PRIVILEGES IN SCHEMA $SCHEMA_NAME GRANT ALL ON TABLES TO $DB_USER;
ALTER DEFAULT PRIVILEGES IN SCHEMA $SCHEMA_NAME GRANT ALL ON SEQUENCES TO $DB_USER;
EOF

echo "✅ Schema '$SCHEMA_NAME' 创建成功"
echo ""

# 4. 运行数据库迁移
echo "📋 Step 4: 运行数据库迁移..."
if [ -f "backend/alembic.ini" ]; then
    echo "正在运行Alembic迁移..."

    # 检查是否使用Docker
    if docker ps | grep -q "todolist-agent.*-backend"; then
        # 在Docker容器中运行
        docker-compose run --rm \
            -e DB_SCHEMA=$SCHEMA_NAME \
            agent1-backend alembic upgrade head || echo "⚠️  迁移可能已存在"
    else
        # 本地运行
        cd backend
        export DB_SCHEMA=$SCHEMA_NAME
        alembic upgrade head || echo "⚠️  迁移可能已存在"
        cd ..
    fi

    echo "✅ 数据库迁移完成"
else
    echo "⚠️  未找到Alembic配置，跳过迁移"
fi
echo ""

# 5. 初始化种子数据
echo "📋 Step 5: 初始化种子数据..."
docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME <<EOF
-- 插入测试用户（如果不存在）
INSERT INTO $SCHEMA_NAME.users (id, username, email, password_hash, xp, level, streak_days, created_at)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'test_user',
    'test@example.com',
    '\$2b\$12\$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYzS3MebAJG',  -- password: test123
    100,
    1,
    0,
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- 插入测试任务
INSERT INTO $SCHEMA_NAME.tasks (id, user_id, title, description, quadrant, status, difficulty, created_at)
VALUES (
    '00000000-0000-0000-0000-000000000101',
    '00000000-0000-0000-0000-000000000001',
    '示例任务：学习Docker',
    '学习Docker基础知识，掌握容器化技术',
    2,  -- 第二象限（重要不紧急）
    'pending',
    3,
    NOW()
) ON CONFLICT (id) DO NOTHING;

EOF

echo "✅ 种子数据初始化完成"
echo ""

# 6. 创建任务存储目录
echo "📋 Step 6: 创建任务存储目录..."
mkdir -p "data/tasks/$AGENT_ID"
echo "✅ 任务目录创建成功: data/tasks/$AGENT_ID"
echo ""

# 7. 环境验证
echo "📋 Step 7: 环境验证..."

# 验证Schema
if docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "\dn $SCHEMA_NAME" 2>/dev/null | grep -q $SCHEMA_NAME; then
    echo "✅ Schema验证通过"
else
    echo "❌ Schema验证失败"
    exit 1
fi

# 验证表
TABLE_COUNT=$(docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$SCHEMA_NAME';")
echo "✅ 数据表数量: $TABLE_COUNT"

echo ""

echo "========================================"
echo "  ✅ 环境初始化完成"
echo "========================================"
echo ""
echo "🎉 Agent '$AGENT_ID' 环境已就绪！"
echo ""
echo "📝 下一步操作："
echo ""
echo "1. 启动开发环境："
echo "   docker-compose --profile $AGENT_ID up"
echo ""
echo "2. 访问地址："
echo "   前端：http://localhost:5173"
echo "   后端：http://localhost:8001"
echo "   API文档：http://localhost:8001/docs"
echo ""
echo "3. 数据库连接："
echo "   Host: localhost"
echo "   Port: 5432"
echo "   Database: $DB_NAME"
echo "   Schema: $SCHEMA_NAME"
echo "   User: $DB_USER"
echo "   Password: $DB_PASSWORD"
echo ""
echo "4. 连接数据库："
echo "   docker exec -it $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME"
echo ""

exit 0