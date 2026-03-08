# 完整开发工作流程

## 概述

本文档描述从领取任务到提交代码的完整开发工作流程，包含环境管理、质量门禁等所有环节。

---

## 1. 工作流程总览

### 1.1 完整状态流转图

```
⏳ 待开始
  ↓ Agent领取任务
🔄 已领取（记录：领取时间、Agent ID）
  ↓ Hook: 环境检查 + 环境初始化
🐳 环境就绪（Docker容器运行，Schema创建，依赖安装）
  ↓ 开始开发
💻 开发中（记录：开始时间）
  ↓ 完成编码，准备提交
🧪 测试中（Hook强制运行所有测试）
  ├─ 测试通过 ✅
  │   ↓ 检查覆盖率 >= 80%
  │   ├─ 覆盖率达标 ✅
  │   │   ↓ Git提交（Hook验证通过）
  │   │   ✅ 已完成（记录：完成时间、提交ID）
  │   └─ 覆盖率不足 ❌
  │       ↓ 必须补充测试用例
  │       💻 回到开发中
  └─ 测试失败 ❌
      ↓ 必须修复代码
      💻 回到开发中（禁止提交）
```

---

## 2. 详细步骤

### Step 1: 领取任务

**操作流程**：
```
1. Agent读取 docs/tasks/task_list.md
2. 筛选状态为 ⏳ 的任务
3. 检查依赖关系（depends_on）
4. 选择符合技能的任务
5. 更新任务状态：⏳ → 🔄
6. 记录领取时间和Agent ID
7. 更新 docs/progress.md
```

**示例命令**：
```bash
# 查看任务列表
cat docs/tasks/task_list.md

# 选择任务ID: B-001
# 更新任务状态（手动编辑或脚本）
# ...
```

---

### Step 2: 环境准备（Hooks自动执行）

#### 2.1 环境检查

**脚本**：`scripts/check-env.sh agent_1`

**检查内容**：
```bash
./scripts/check-env.sh agent_1

# 输出示例：
# === 环境检查：agent_1 ===
# ✅ Docker运行正常
# ✅ 数据库容器运行正常
# ⚠️  Schema不存在，需要初始化
# ⚠️  Python虚拟环境不存在
# === 环境检查完成 ===
```

#### 2.2 环境初始化

**脚本**：`scripts/init-agent-env.sh agent_1`

**初始化流程**：
```bash
./scripts/init-agent-env.sh agent_1

# 执行内容：
# 1. 启动数据库容器
# 2. 创建agent_1专属schema
# 3. 运行数据库迁移
# 4. 初始化种子数据
# 5. 创建任务存储目录
```

#### 2.3 启动开发环境

**命令**：
```bash
# 启动Agent 1的开发环境
docker-compose --profile agent_1 up

# 后台运行
docker-compose --profile agent_1 up -d

# 查看日志
docker-compose --profile agent_1 logs -f
```

**访问地址**：
- 前端：http://localhost:5173
- 后端：http://localhost:8001
- API文档：http://localhost:8001/docs

---

### Step 3: 开发编码

#### 3.1 查阅设计文档

```bash
# API规范
cat docs/design/api_specification.md

# 前端组件设计
cat docs/design/frontend_component_design.md

# 数据库设计
cat docs/design/database_schema.md
```

#### 3.2 创建开发分支

```bash
# 从main分支创建新分支
git checkout main
git pull origin main
git checkout -b feature/B-001-user-registration

# 分支命名规范
# feature/<task-id>-<brief-description>
# 示例：feature/B-001-user-registration
```

#### 3.3 编写代码

**后端开发流程**：
```
1. 定义数据模型（app/models/）
2. 编写业务逻辑（app/services/）
3. 实现API路由（app/api/v1/endpoints/）
4. 编写单元测试（tests/unit/）
```

**前端开发流程**：
```
1. 定义组件（src/components/）
2. 实现状态管理（src/stores/）
3. 编写API调用（src/api/）
4. 编写单元测试（tests/）
```

#### 3.4 本地测试验证

```bash
# 后端单元测试
cd backend
poetry run pytest tests/unit -v

# 测试覆盖率
poetry run pytest tests/unit --cov=app --cov-report=term-missing

# 前端单元测试
cd frontend
npm run test
```

---

### Step 4: 质量门禁（Hooks强制执行）

#### 4.1 尝试提交代码

```bash
git add .
git commit -m "feat(auth): 实现用户注册API

Task: B-001
Time: 5.5h
Coverage: 85%

- 添加 POST /api/v1/auth/register 接口
- 实现用户名、邮箱、密码验证
- 密码使用 bcrypt 加密存储
- 返回 JWT token
- 单元测试覆盖率 85%

Closes #B-001"
```

#### 4.2 Pre-commit Hook自动执行

**Hook检查流程**：

```
========================================
  🔍 运行 Pre-commit 质量检查
========================================

📋 检查1: 代码格式检查
----------------------------------------
✅ 代码格式检查通过

📋 检查2: 运行所有单元测试
----------------------------------------
✅ 所有单元测试通过

📋 检查3: 测试覆盖率检查
----------------------------------------
✅ 测试覆盖率达标（>= 80%）

========================================
  ✅ 所有质量检查通过
========================================

🎉 代码质量良好，可以提交！
```

#### 4.3 测试失败处理

**如果测试失败**：
```
========================================
  🔍 运行 Pre-commit 质量检查
========================================

📋 检查2: 运行所有单元测试
----------------------------------------
FAILED tests/unit/test_auth.py::test_register - AssertionError

❌ 单元测试失败！

💡 提示：
   1. 查看上面的错误信息
   2. 修复失败的测试
   3. 重新运行: poetry run pytest tests/unit -v
   4. 所有测试通过后重新提交

⚠️  注意：测试失败的代码不允许提交到代码库
```

**处理流程**：
```bash
# 1. 查看错误详情
poetry run pytest tests/unit/test_auth.py::test_register -v

# 2. 修复代码
# 编辑源代码或测试代码

# 3. 重新运行测试
poetry run pytest tests/unit -v

# 4. 测试通过后重新提交
git add .
git commit -m "..."
```

---

### Step 5: 提交和更新

#### 5.1 推送代码

```bash
# 推送到远程分支
git push origin feature/B-001-user-registration
```

#### 5.2 创建Pull Request

**PR模板**：
```markdown
## 变更说明
- 实现用户注册API
- 添加相关单元测试

## 测试情况
- 测试覆盖率：85%
- 所有测试用例通过

## 相关文档
- API规范文档：docs/design/api_specification.md
- 数据库设计：docs/design/database_schema.md

## Checklist
- [x] 代码符合规范
- [x] 单元测试通过
- [x] 测试覆盖率达标（>= 80%）
- [x] 文档已更新

Closes #B-001
```

#### 5.3 代码审查

**审查流程**：
```
1. 架构师审查代码
2. 检查代码质量
3. 检查架构设计
4. 检查测试质量
5. 提出修改意见（如有）
6. 批准合并
```

#### 5.4 PR合并后更新环境

**Post-merge Hook自动执行**：
```bash
# .git/hooks/post-merge 自动运行

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

echo "=== 环境更新完成 ==="
```

#### 5.5 更新进度文档

```markdown
# 更新 docs/progress.md

## 最近更新记录

| 日期 | 更新内容 | 操作者 |
|------|----------|--------|
| 2026-03-08 14:30 | B-001: 用户注册API 已完成 ✅ | 后端开发Agent |
| 2026-03-08 14:00 | B-001: 用户注册API 测试通过 | 后端开发Agent |
```

---

## 3. 环境更新通知机制

### 3.1 通知其他Agent

**机制**：
1. PR合并后，post-merge hook自动更新环境
2. 更新 `docs/progress.md` 记录变更
3. 其他Agent定期（每日）`git pull`
4. Pull后自动运行环境检查和更新

### 3.2 环境同步流程

```
Agent A完成开发
    │
    ├─→ git push
    ├─→ PR合并
    └─→ post-merge hook更新环境

其他Agent同步
    │
    ├─→ git pull
    ├─→ post-merge hook检查更新
    │   ├─ 依赖变化 → 更新依赖
    │   └─ 数据库迁移 → 运行迁移
    └─→ 环境同步完成
```

---

## 4. 异常处理

### 4.1 测试失败

**处理流程**：
```
测试失败 ❌
    │
    ├─→ 查看错误信息
    ├─→ 定位问题
    ├─→ 修复代码
    ├─→ 重新测试
    └─→ 测试通过 ✅
        └─→ 重新提交
```

**禁止操作**：
- ❌ 使用 `--no-verify` 绕过Hook
- ❌ 删除失败的测试
- ❌ 注释掉失败的断言

### 4.2 覆盖率不足

**处理流程**：
```
覆盖率不足 ❌ (< 80%)
    │
    ├─→ 查看覆盖率报告
    ├─→ 分析未覆盖代码
    ├─→ 编写测试用例
    ├─→ 重新检查覆盖率
    └─→ 覆盖率达标 ✅ (>= 80%)
        └─→ 重新提交
```

### 4.3 环境问题

**常见问题**：
1. **Schema不存在**
   ```bash
   ./scripts/init-agent-env.sh agent_1
   ```

2. **数据库连接失败**
   ```bash
   docker-compose restart postgres
   ```

3. **依赖冲突**
   ```bash
   cd backend
   poetry lock
   poetry install
   ```

### 4.4 连续失败处理

**规则**：
- 连续3次测试失败 → 🚫 被阻塞
- 请求架构师协助
- 记录阻塞原因到 `docs/progress.md`

---

## 5. 最佳实践

### 5.1 提交频率

**推荐**：
- 每完成一个小功能就提交
- 避免一次性提交大量代码
- 保持提交历史清晰

**示例**：
```bash
# 好的提交习惯
git commit -m "feat: 添加用户注册API接口"
git commit -m "test: 添加用户注册API单元测试"
git commit -m "docs: 更新API文档"

# 不好的提交习惯
git commit -m "feat: 完成所有用户管理功能"  # 太大
```

### 5.2 测试策略

**推荐**：
1. **先写测试，后写代码（TDD）**
2. **测试覆盖所有边界条件**
3. **测试失败的代码**
4. **测试异常情况**

**示例**：
```python
# 好的测试用例
def test_register_success():
    # 正常情况
    pass

def test_register_duplicate_email():
    # 重复邮箱
    pass

def test_register_invalid_email():
    # 无效邮箱格式
    pass

def test_register_weak_password():
    # 弱密码
    pass
```

### 5.3 代码质量

**推荐**：
1. **遵循编码规范**
2. **添加类型注解**
3. **编写清晰的注释**
4. **保持函数简洁**

---

## 6. 常用命令速查

### 6.1 环境管理

```bash
# 初始化环境
./scripts/init-agent-env.sh agent_1

# 启动开发环境
docker-compose --profile agent_1 up

# 停止环境
docker-compose --profile agent_1 down

# 查看日志
docker-compose --profile agent_1 logs -f

# 重建容器
docker-compose --profile agent_1 up --build
```

### 6.2 开发调试

```bash
# 运行测试
poetry run pytest tests/unit -v

# 测试覆盖率
poetry run pytest tests/unit --cov=app --cov-report=term-missing

# 代码格式化
poetry run black app/ tests/

# 代码质量检查
poetry run flake8 app/ tests/

# 类型检查
poetry run mypy app/
```

### 6.3 Git操作

```bash
# 创建分支
git checkout -b feature/B-001-xxx

# 提交代码
git add .
git commit -m "..."

# 推送代码
git push origin feature/B-001-xxx

# 更新本地
git pull origin main

# 查看状态
git status
git log --oneline -10
```

---

## 7. 参考资料

- [环境管理架构设计](../architecture/environment-management.md)
- [质量门禁设计](../architecture/quality-gate.md)
- [任务管理规范](./task-management.md)
- [开发Agent指南](./agent-guide.md)

---

**文档编写人**: Claude Code
**编写日期**: 2026-03-08
**最后更新**: 2026-03-08