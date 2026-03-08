# 快速开始指南

## 🎯 已完成的工作

### 1. 文档体系（保存在 `docs/develop/`）
- ✅ 环境管理架构设计
- ✅ 强制质量门禁设计
- ✅ 完整开发工作流程

### 2. 环境管理脚本（保存在 `scripts/`）
- ✅ `check-env.sh` - 环境检查脚本
- ✅ `init-agent-env.sh` - 环境初始化脚本
- ✅ `init-schemas.sql` - 数据库Schema初始化SQL

### 3. Docker Compose配置
- ✅ `docker-compose.yml` - 多Agent开发环境配置
  - 共享PostgreSQL数据库
  - Agent专属容器（支持profile启动）
  - Schema隔离机制

### 4. 强制质量门禁
- ✅ `.pre-commit-config.yaml` - Pre-commit框架配置
- ✅ `.git/hooks/pre-commit` - Git pre-commit hook（强制测试）

---

## 🚀 快速开始

### 方案A：查看文档了解设计思路

```bash
# 查看文档目录
ls -la docs/develop/

# 阅读环境管理架构
cat docs/develop/architecture/environment-management.md

# 阅读质量门禁设计
cat docs/develop/architecture/quality-gate.md

# 阅读完整工作流程
cat docs/develop/workflow/development-workflow.md
```

### 方案B：立即使用脚本初始化环境

```bash
# 1. 检查环境
./scripts/check-env.sh agent_1

# 2. 初始化环境
./scripts/init-agent-env.sh agent_1

# 3. 启动开发容器
docker-compose --profile agent_1 up

# 4. 访问应用
# 前端：http://localhost:5173
# 后端：http://localhost:8001
# API文档：http://localhost:8001/docs
```

### 方案C：测试强制质量门禁

```bash
# 尝试提交代码（会自动运行测试）
git add .
git commit -m "test: 测试质量门禁"

# 如果测试失败，提交会被阻止
# 如果测试通过，提交成功
```

---

## 📁 文件清单

### 文档文件
```
docs/develop/
├── README.md
├── architecture/
│   ├── environment-management.md  ✅ 环境管理架构设计
│   └── quality-gate.md            ✅ 强制质量门禁设计
└── workflow/
    └── development-workflow.md    ✅ 完整开发工作流程
```

### 脚本文件
```
scripts/
├── check-env.sh         ✅ 环境检查脚本
├── init-agent-env.sh    ✅ 环境初始化脚本
└── init-schemas.sql     ✅ 数据库Schema初始化
```

### 配置文件
```
.
├── docker-compose.yml           ✅ Docker Compose配置
├── .pre-commit-config.yaml      ✅ Pre-commit框架配置
└── .git/hooks/pre-commit        ✅ Git pre-commit hook
```

---

## 🎯 核心功能演示

### 1. 环境管理演示

```bash
# 场景：Agent领取任务后，初始化开发环境

# Step 1: 检查环境状态
./scripts/check-env.sh agent_1

# 输出示例：
# ========================================
#   🔍 环境检查：agent_1
# ========================================
# ✅ Docker运行正常
# ⚠️  Schema不存在，需要初始化
# ========================================

# Step 2: 初始化环境
./scripts/init-agent-env.sh agent_1

# 输出示例：
# ========================================
#   🚀 初始化Agent环境：agent_1
# ========================================
# ✅ Schema 'agent_1' 创建成功
# ✅ 数据库迁移完成
# ✅ 种子数据初始化完成
# ========================================

# Step 3: 启动开发环境
docker-compose --profile agent_1 up

# 输出示例：
# [+] Running 3/3
#  ✔ Network todolist-dev         Created
#  ✔ Container todolist-db        Started
#  ✔ Container todolist-agent1-backend  Started
```

### 2. 强制质量门禁演示

```bash
# 场景：开发者提交代码

# 测试失败情况
git commit -m "feat: 添加新功能"

# 输出示例（测试失败）：
# ========================================
#   🔍 运行 Pre-commit 质量检查
# ========================================
# ❌ 单元测试失败！
# ⚠️  注意：测试失败的代码不允许提交到代码库
# [提交被阻止]

# 测试通过情况
# 输出示例（测试通过）：
# ========================================
#   🔍 运行 Pre-commit 质量检查
# ========================================
# ✅ 代码格式检查通过
# ✅ 所有单元测试通过
# ✅ 测试覆盖率达标（>= 80%）
# ========================================
# 🎉 代码质量良好，可以提交！
# [提交成功]
```

---

## 🔧 配置说明

### Docker Compose配置要点

**共享数据库**：
```yaml
postgres:
  image: postgres:15-alpine
  ports: ["5432:5432"]
  volumes: [postgres_data:/var/lib/postgresql/data]
```

**Agent专属容器**：
```yaml
agent1-backend:
  profiles: ["agent_1"]  # 按需启动
  environment:
    DB_SCHEMA: agent_1    # Schema隔离
  ports: ["8001:8000"]
```

**启动命令**：
```bash
# 只启动Agent 1环境
docker-compose --profile agent_1 up

# 启动多个Agent环境
docker-compose --profile agent_1 --profile agent_2 up
```

### Pre-commit Hook配置要点

**强制检查**：
1. 代码格式检查（black）
2. 运行所有单元测试（pytest）
3. 测试覆盖率 >= 80%（pytest-cov）

**阻止提交条件**：
- 任何测试失败
- 覆盖率 < 80%
- 代码格式不符合规范

---

## 📝 下一步建议

### 优先级1：创建项目骨架
1. 创建 `backend/` 目录并初始化FastAPI项目
2. 创建 `frontend/` 目录并初始化Vue3项目
3. 配置测试框架（Pytest, Vitest）

### 优先级2：测试环境管理
```bash
# 测试环境初始化脚本
./scripts/init-agent-env.sh agent_1

# 检查环境是否正常
docker-compose --profile agent_1 ps

# 验证Schema隔离
docker exec todolist-db psql -U dev -d todolist -c "\dn"
```

### 优先级3：测试质量门禁
```bash
# 创建一个简单的测试文件
# 尝试提交代码，观察Hook是否生效
git add .
git commit -m "test: 测试质量门禁"
```

---

## ❓ 常见问题

### Q1: 如何添加新的Agent环境？

**答**：编辑 `docker-compose.yml`，添加新的服务配置：

```yaml
agent3-backend:
  profiles: ["agent_3"]
  environment:
    DB_SCHEMA: agent_3
  ports: ["8003:8000"]
  # ... 其他配置
```

### Q2: 如何绕过质量门禁？

**答**：**不推荐**，但可以使用：
```bash
git commit --no-verify -m "..."
```

**注意**：这会降低代码质量，应该避免使用。

### Q3: 如何查看测试覆盖率报告？

**答**：运行测试时会自动显示：
```bash
cd backend
poetry run pytest tests/unit --cov=app --cov-report=html
open htmlcov/index.html  # 查看详细报告
```

### Q4: Schema隔离会影响性能吗？

**答**：不会。Schema隔离是PostgreSQL的标准功能，性能影响极小。

---

## 📚 参考资料

- [环境管理架构设计](docs/develop/architecture/environment-management.md)
- [强制质量门禁设计](docs/develop/architecture/quality-gate.md)
- [完整开发工作流程](docs/develop/workflow/development-workflow.md)

---

**创建日期**: 2026-03-08
**创建人**: Claude Code