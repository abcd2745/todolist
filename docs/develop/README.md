# 开发阶段文档

## 目录结构

```
docs/develop/
├── architecture/          # 架构设计文档
│   ├── environment-management.md    # 环境管理架构
│   └── quality-gate.md              # 质量门禁设计
├── scripts/               # 脚本文档
│   ├── environment-init.md          # 环境初始化脚本
│   └── quality-check.md             # 质量检查脚本
└── workflow/              # 工作流程文档
    ├── development-workflow.md      # 完整开发工作流程
    ├── task-management.md           # 任务管理规范
    └── agent-guide.md               # 开发Agent指南
```

## 文档说明

### 架构设计文档
- `environment-management.md` - Docker Compose环境管理架构设计
- `quality-gate.md` - 强制质量门禁设计（Pre-commit Hooks）

### 脚本文档
- `environment-init.md` - 环境初始化脚本使用说明
- `quality-check.md` - 质量检查脚本使用说明

### 工作流程文档
- `development-workflow.md` - 完整的开发工作流程（含环境管理）
- `task-management.md` - 任务拆解、领取、状态管理规范
- `agent-guide.md` - 开发Agent工作指南

## 快速开始

### 1. 环境准备
```bash
# 初始化开发环境
./scripts/init-agent-env.sh agent_1

# 启动开发容器
docker-compose --profile agent_1 up
```

### 2. 开发流程
```bash
# 1. 领取任务
# 2. 编写代码和单元测试
# 3. 提交代码（自动运行测试）
git commit -m "feat: 完成XX功能"
```

### 3. 质量门禁
- 测试失败：禁止提交
- 覆盖率不足（<80%）：禁止提交
- 必须修复所有问题才能提交

## 文档编写日期

- **创建日期**: 2026-03-08
- **最后更新**: 2026-03-08
- **负责人**: Claude Code