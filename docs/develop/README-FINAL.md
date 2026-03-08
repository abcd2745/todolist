# 极简开发方案 - 最终版

## 🎯 设计原则

**一个数据库 + Schema隔离 + 按需清理**

---

## ✅ 核心优势

1. **极简** - 只启动1个PostgreSQL容器
2. **无冲突** - 所有Agent共享端口5432
3. **高效** - Schema隔离，资源共享
4. **易清理** - 删除Schema即可重置

---

## 🚀 快速开始

### 1. 启动数据库（一次性）

```bash
docker-compose up -d
```

### 2. Agent创建环境

```bash
# Agent 1
./scripts/agent-env.sh agent_1 create

# Agent 2
./scripts/agent-env.sh agent_2 create

# Agent 3
./scripts/agent-env.sh agent_3 create
```

### 3. 开发测试

```bash
# 连接数据库
docker exec -it todolist-db psql -U dev -d todolist

# 切换到专属Schema
SET search_path TO agent_1;

# 创建表、插入数据、测试...
```

### 4. 清理环境

```bash
# 测试完成后清理
./scripts/agent-env.sh agent_1 clean
```

---

## 📁 文件结构

```
.
├── docker-compose.yml          # 极简版（仅数据库）
├── scripts/
│   ├── setup-db.sh             # 启动数据库
│   └── agent-env.sh            # Agent环境管理
└── docs/develop/
    ├── README-FINAL.md         # 本文件
    └── WORKFLOW-SIMPLE.md      # 详细工作流程
```

---

## 📋 核心命令速查

```bash
# 启动数据库
docker-compose up -d

# 创建Agent环境
./scripts/agent-env.sh agent_X create

# 查看所有Schema
docker exec -it todolist-db psql -U dev -d todolist -c "\dn"

# 清理Agent环境
./scripts/agent-env.sh agent_X clean

# 重置Agent环境
./scripts/agent-env.sh agent_X reset
```

---

## 🎯 典型场景

### 场景1：领取新任务

```bash
# 1. 创建环境
./scripts/agent-env.sh agent_1 create

# 2. 开始开发
# 配置: DB_SCHEMA=agent_1
# 编码、测试...

# 3. 提交代码
git add .
git commit -m "feat: 完成XX功能"

# 4. 清理环境（可选）
./scripts/agent-env.sh agent_1 clean
```

### 场景2：多人协作

```bash
# Agent 1
./scripts/agent-env.sh agent_alice create

# Agent 2
./scripts/agent-env.sh agent_bob create

# Agent 3
./scripts/agent-env.sh agent_charlie create

# 所有人同时工作，互不干扰
```

### 场景3：CI/CD测试

```bash
# 创建测试环境
./scripts/agent-env.sh ci_test_$BUILD_ID create

# 运行测试
DB_SCHEMA=ci_test_$BUILD_ID pytest tests/

# 清理环境
./scripts/agent-env.sh ci_test_$BUILD_ID clean
```

---

## 📊 对比总结

| 项目 | 复杂方案 | 极简方案 |
|------|----------|----------|
| 容器数量 | 3-6个/Agent | 1个共享 |
| 端口管理 | 需要协调 | 固定5432 |
| 启动时间 | 慢（多容器） | 快（单容器） |
| 资源消耗 | 高 | 低 |
| 并发支持 | 需配置 | 天然支持 |
| 清理难度 | 复杂 | 简单 |
| 学习曲线 | 陡峭 | 平缓 |

---

## 💡 为什么这个方案最好？

### 1. **真实场景优化**
```bash
# 实际开发中：
# - 团队共享开发/测试环境
# - 不同开发者需要独立数据
# - Schema隔离最简单直接
```

### 2. **避免过度设计**
```
不需要：
- 多个数据库容器
- 复杂的端口管理
- 多环境配置文件

只需要：
- 1个数据库
- Schema隔离
- 简单脚本
```

### 3. **易于理解和维护**
```bash
# 清晰的命令
./scripts/agent-env.sh agent_1 create  # 创建
./scripts/agent-env.sh agent_1 clean   # 清理

# 无需理解：
# - Profile机制
# - 端口分配
# - Volume策略
```

---

## 🔧 扩展建议

### 未来可以添加

#### 1. 自动清理脚本

```bash
# scripts/cleanup-old-schemas.sh
# 清理超过7天未使用的Schema
```

#### 2. Schema使用统计

```bash
# scripts/schema-stats.sh
# 显示每个Schema的大小和表数量
```

#### 3. 数据快照

```bash
# scripts/snapshot-schema.sh
# 备份Schema数据
```

---

## 📝 立即开始

```bash
# 1. 启动数据库
docker-compose up -d

# 2. 创建你的环境
./scripts/agent-env.sh my_agent create

# 3. 开始开发
docker exec -it todolist-db psql -U dev -d todolist
SET search_path TO my_agent;

# 4. 清理
./scripts/agent-env.sh my_agent clean
```

---

**创建日期**: 2026-03-08
**状态**: ✅ 生产就绪
**推荐使用**: 所有开发测试场景