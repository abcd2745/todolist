# 强制质量门禁设计

## 概述

本文档描述强制质量门禁的实现方案，确保**测试通过才能提交，不通过不能提交，必须修复**。

---

## 1. 核心需求

### 1.1 必须实现的功能
- ✅ 测试通过才能提交
- ✅ 不通过不能提交，必须修复
- ✅ 强制运行所有测试案例
- ✅ 测试覆盖率 > 80%

### 1.2 设计目标
- **自动化**：提交代码时自动运行检查
- **强制性**：测试失败时阻止提交
- **透明性**：明确的错误提示
- **快速反馈**：快速发现问题

---

## 2. 质量门禁架构

### 2.1 整体架构

```
┌─────────────────────────────────────────────────────────────────────┐
│                      质量门禁强制流程                                  │
└─────────────────────────────────────────────────────────────────────┘

开发者尝试提交代码 (git commit)
         │
         ▼
┌─────────────────────────────────────────────────────────────────────┐
│  Pre-commit Hook 自动执行                                            │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │  检查1: 代码格式检查 (black, flake8)                          │ │
│  │    ├─ 通过 ✅ → 继续                                         │ │
│  │    └─ 失败 ❌ → 阻止提交                                     │ │
│  └───────────────────────────────────────────────────────────────┘ │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │  检查2: 运行所有单元测试                                     │ │
│  │    ├─ 通过 ✅ → 继续                                         │ │
│  │    └─ 失败 ❌ → 阻止提交，必须修复                           │ │
│  └───────────────────────────────────────────────────────────────┘ │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │  检查3: 测试覆盖率 >= 80%                                    │ │
│  │    ├─ 达标 ✅ → 允许提交                                     │ │
│  │    └─ 不足 ❌ → 阻止提交，必须补充测试                       │ │
│  └───────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
         │
         ▼
所有检查通过 ✅ → Git允许提交
```

### 2.2 技术实现

**核心机制：Git Pre-commit Hook**

**原理**：
1. Git在执行`git commit`前会调用`.git/hooks/pre-commit`脚本
2. 如果脚本返回非零退出码，Git拒绝提交
3. 所有输出会显示给开发者

**关键优势**：
- ✅ **强制执行**：无法绕过Hook（除非使用`--no-verify`，但不推荐）
- ✅ **自动化**：提交时自动运行，无需手动触发
- ✅ **快速反馈**：立即发现问题

---

## 3. Pre-commit Hook实现

### 3.1 完整脚本

**文件位置**：`.git/hooks/pre-commit`

```bash
#!/bin/bash
# =============================================================================
# Pre-commit Hook: 强制质量门禁
# =============================================================================
# 功能：确保测试通过才能提交代码
# 规则：
#   1. 代码格式检查必须通过
#   2. 所有单元测试必须通过
#   3. 测试覆盖率 >= 80%
# =============================================================================

set -e  # 任何命令失败都退出

echo "========================================"
echo "  🔍 运行 Pre-commit 质量检查"
echo "========================================"
echo ""

# =============================================================================
# 检查1: 代码格式检查
# =============================================================================
echo "📋 检查1: 代码格式检查"
echo "----------------------------------------"

cd backend

# Black格式检查
if ! poetry run black --check app/ tests/; then
    echo ""
    echo "❌ 代码格式检查失败！"
    echo ""
    echo "💡 提示：运行以下命令自动修复格式问题："
    echo "   poetry run black app/ tests/"
    echo ""
    exit 1
fi

# Flake8代码质量检查
if ! poetry run flake8 app/ tests/ --max-line-length=88 --extend-ignore=E203,W503; then
    echo ""
    echo "❌ 代码质量检查失败！"
    echo ""
    echo "💡 提示：请修复以上代码质量问题"
    echo ""
    exit 1
fi

echo "✅ 代码格式检查通过"
echo ""

# =============================================================================
# 检查2: 运行所有单元测试（强制）
# =============================================================================
echo "📋 检查2: 运行所有单元测试"
echo "----------------------------------------"

if ! poetry run pytest tests/unit -v --tb=short; then
    echo ""
    echo "❌ 单元测试失败！"
    echo ""
    echo "💡 提示："
    echo "   1. 查看上面的错误信息"
    echo "   2. 修复失败的测试"
    echo "   3. 重新运行: poetry run pytest tests/unit -v"
    echo "   4. 所有测试通过后重新提交"
    echo ""
    echo "⚠️  注意：测试失败的代码不允许提交到代码库"
    echo ""
    exit 1
fi

echo "✅ 所有单元测试通过"
echo ""

# =============================================================================
# 检查3: 测试覆盖率检查（强制 >= 80%）
# =============================================================================
echo "📋 检查3: 测试覆盖率检查"
echo "----------------------------------------"

if ! poetry run pytest tests/unit --cov=app --cov-fail-under=80 --cov-report=term-missing; then
    echo ""
    echo "❌ 测试覆盖率不足 80%！"
    echo ""
    echo "💡 提示："
    echo "   1. 查看上面的覆盖率报告"
    echo "   2. 为未覆盖的代码添加测试"
    echo "   3. 重新运行: poetry run pytest tests/unit --cov=app"
    echo "   4. 覆盖率达到 80% 后重新提交"
    echo ""
    echo "⚠️  注意：测试覆盖率低于 80% 的代码不允许提交"
    echo ""
    exit 1
fi

echo "✅ 测试覆盖率达标（>= 80%）"
echo ""

# =============================================================================
# 所有检查通过
# =============================================================================
echo "========================================"
echo "  ✅ 所有质量检查通过"
echo "========================================"
echo ""
echo "🎉 代码质量良好，可以提交！"
echo ""

exit 0
```

### 3.2 脚本权限设置

```bash
# 设置可执行权限
chmod +x .git/hooks/pre-commit
```

---

## 4. Pre-commit框架配置

### 4.1 配置文件

**文件位置**：`.pre-commit-config.yaml`

```yaml
# =============================================================================
# Pre-commit框架配置
# =============================================================================
# 功能：自动化代码质量检查
# 安装：pip install pre-commit && pre-commit install
# 运行：pre-commit run --all-files
# =============================================================================

repos:
  # 通用检查
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace       # 删除行尾空白
      - id: end-of-file-fixer         # 确保文件以换行结束
      - id: check-yaml                # YAML语法检查
      - id: check-added-large-files   # 检查大文件
        args: ['--maxkb=500']
      - id: check-merge-conflict      # 检查合并冲突标记
      - id: debug-statements          # 检查debug语句

  # Python代码格式化
  - repo: https://github.com/psf/black
    rev: 24.1.0
    hooks:
      - id: black
        language_version: python3.11
        args: [--line-length=88]

  # Python代码质量检查
  - repo: https://github.com/pycqa/flake8
    rev: 7.0.0
    hooks:
      - id: flake8
        args: [--max-line-length=88, --extend-ignore=E203,W503]

  # Python导入排序
  - repo: https://github.com/pycqa/isort
    rev: 5.13.0
    hooks:
      - id: isort
        args: [--profile=black, --line-length=88]

  # Python类型检查（警告，不阻止提交）
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        args: [--ignore-missing-imports, --no-error-summary]
        verbose: true

  # 本地自定义Hook：强制测试
  - repo: local
    hooks:
      - id: pytest
        name: Run pytest with coverage
        entry: bash -c 'cd backend && poetry run pytest tests/unit -v --cov=app --cov-fail-under=80'
        language: system
        pass_filenames: false
        always_run: true
        stages: [commit]
        verbose: true
```

### 4.2 安装和配置

```bash
# 安装pre-commit
pip install pre-commit

# 安装Git hooks
pre-commit install

# 手动运行所有检查
pre-commit run --all-files

# 更新到最新版本
pre-commit autoupdate
```

---

## 5. 质量门禁规则详解

### 5.1 强制检查（必须通过）

| 检查项 | 工具 | 阻止提交条件 | 解决方案 |
|--------|------|--------------|----------|
| 代码格式 | black | 格式不符合规范 | 运行`black app/ tests/`自动修复 |
| 代码质量 | flake8 | 存在代码质量问题 | 修复提示的问题 |
| 单元测试 | pytest | 任何测试失败 | 修复失败的测试 |
| 测试覆盖率 | pytest-cov | 覆盖率 < 80% | 添加测试用例 |

### 5.2 警告检查（不阻止提交）

| 检查项 | 工具 | 说明 |
|--------|------|------|
| 类型检查 | mypy | 类型注解警告，不阻止提交 |
| 复杂度检查 | flake8-cognitive-complexity | 代码复杂度警告 |

---

## 6. 失败处理流程

### 6.1 测试失败处理

```
测试失败 ❌
    │
    ├─→ 查看错误信息
    │   └─ pytest显示失败的测试和错误详情
    │
    ├─→ 定位问题
    │   ├─ 业务逻辑错误？
    │   ├─ 测试代码错误？
    │   └─ 环境配置错误？
    │
    ├─→ 修复代码
    │   └─ 编辑源代码或测试代码
    │
    ├─→ 重新运行测试
    │   └─ poetry run pytest tests/unit -v
    │
    └─→ 测试通过 ✅
        └─ 重新提交代码
```

### 6.2 覆盖率不足处理

```
覆盖率不足 ❌ (< 80%)
    │
    ├─→ 查看覆盖率报告
    │   └─ pytest显示未覆盖的代码行
    │
    ├─→ 分析未覆盖代码
    │   ├─ 业务逻辑代码？
    │   ├─ 异常处理代码？
    │   └─ 边界条件代码？
    │
    ├─→ 编写测试用例
    │   └─ 为未覆盖的代码添加测试
    │
    ├─→ 重新运行覆盖率检查
    │   └─ poetry run pytest tests/unit --cov=app
    │
    └─→ 覆盖率达标 ✅ (>= 80%)
        └─ 重新提交代码
```

---

## 7. CI/CD集成

### 7.1 GitHub Actions配置

**文件位置**：`.github/workflows/test.yml`

```yaml
name: Quality Gate

on:
  pull_request:
  push:
    branches: [main]

jobs:
  quality-gate:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_PASSWORD: test
          POSTGRES_DB: todolist_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          cd backend
          pip install poetry
          poetry install

      - name: Run pre-commit
        run: |
          pip install pre-commit
          pre-commit run --all-files

      - name: Run tests with coverage
        env:
          DATABASE_URL: postgresql://postgres:test@localhost:5432/todolist_test
          DB_SCHEMA: public
        run: |
          cd backend
          poetry run pytest tests/ -v --cov=app --cov-report=xml

      - name: Upload coverage
        uses: codecov/codecov-action@v3

      - name: Check coverage threshold
        run: |
          cd backend
          poetry run coverage report --fail-under=80
```

---

## 8. 性能优化

### 8.1 测试性能优化

**问题**：每次提交都运行所有测试，可能较慢

**解决方案**：

1. **并行运行测试**
   ```bash
   pytest tests/unit -n auto  # 使用pytest-xdist并行运行
   ```

2. **使用内存数据库**
   ```python
   # tests/conftest.py
   @pytest.fixture
   def db():
       engine = create_engine("sqlite:///:memory:")
       # ...
   ```

3. **分层测试**
   ```
   单元测试（快速） → 每次提交运行
   集成测试（中速） → CI运行
   E2E测试（慢速）  → 手动触发或定时运行
   ```

### 8.2 钩子性能优化

**优化策略**：

```bash
# 只检查修改的文件（不推荐，可能遗漏问题）
git diff --cached --name-only --diff-filter=ACM | grep '\.py$' | xargs pytest

# 推荐：运行所有测试，确保质量
pytest tests/unit -v
```

---

## 9. 最佳实践

### 9.1 开发最佳实践

1. **频繁提交小改动**
   ```bash
   # 每完成一个小功能就提交
   # 避免一次性提交大量代码
   ```

2. **先写测试，后写代码（TDD）**
   ```bash
   # 1. 编写测试（失败）
   # 2. 编写代码使测试通过
   # 3. 重构代码
   ```

3. **本地先运行测试**
   ```bash
   # 提交前本地运行测试
   poetry run pytest tests/unit -v
   ```

### 9.2 团队协作最佳实践

1. **统一配置**
   ```bash
   # 将pre-commit配置加入版本控制
   git add .pre-commit-config.yaml
   ```

2. **定期更新工具版本**
   ```bash
   pre-commit autoupdate
   ```

3. **文档化规范**
   ```markdown
   # 编码规范
   - 代码格式：black
   - 代码质量：flake8
   - 测试覆盖率：>= 80%
   ```

---

## 10. 故障排查

### 10.1 Hook不执行

**问题**：提交时Hook不运行

**解决方案**：
```bash
# 检查Hook是否存在
ls -la .git/hooks/pre-commit

# 设置权限
chmod +x .git/hooks/pre-commit

# 重新安装
pre-commit install
```

### 10.2 测试超时

**问题**：测试运行时间过长

**解决方案**：
```bash
# 设置超时
pytest tests/unit --timeout=10

# 并行运行
pytest tests/unit -n auto
```

### 10.3 覆盖率报告不准确

**问题**：覆盖率报告不符合预期

**解决方案**：
```bash
# 清除旧的覆盖率数据
coverage erase

# 重新运行
pytest tests/unit --cov=app --cov-report=term-missing
```

---

## 11. 参考资料

- [Pre-commit官方文档](https://pre-commit.com/)
- [Pytest文档](https://docs.pytest.org/)
- [Black代码格式化工具](https://black.readthedocs.io/)
- [Flake8代码质量检查](https://flake8.pycqa.org/)
- [Coverage.py覆盖率工具](https://coverage.readthedocs.io/)

---

**文档编写人**: Claude Code
**编写日期**: 2026-03-08
**最后更新**: 2026-03-08