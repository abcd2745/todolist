-- =============================================================================
-- 数据库Schema初始化SQL
-- =============================================================================
-- 功能：为每个Agent创建独立的Schema
-- 执行：Docker容器启动时自动执行
-- =============================================================================

-- 创建agent_1 schema
CREATE SCHEMA IF NOT EXISTS agent_1;
GRANT ALL PRIVILEGES ON SCHEMA agent_1 TO dev;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA agent_1 TO dev;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA agent_1 TO dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA agent_1 GRANT ALL ON TABLES TO dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA agent_1 GRANT ALL ON SEQUENCES TO dev;

-- 创建agent_2 schema
CREATE SCHEMA IF NOT EXISTS agent_2;
GRANT ALL PRIVILEGES ON SCHEMA agent_2 TO dev;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA agent_2 TO dev;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA agent_2 TO dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA agent_2 GRANT ALL ON TABLES TO dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA agent_2 GRANT ALL ON SEQUENCES TO dev;

-- 创建agent_3 schema（预留）
CREATE SCHEMA IF NOT EXISTS agent_3;
GRANT ALL PRIVILEGES ON SCHEMA agent_3 TO dev;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA agent_3 TO dev;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA agent_3 TO dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA agent_3 GRANT ALL ON TABLES TO dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA agent_3 GRANT ALL ON SEQUENCES TO dev;

-- 设置search_path默认值（可选）
-- ALTER USER dev SET search_path TO public, agent_1;