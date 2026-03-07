# 游戏化待办事项系统

## 项目概要

**项目**：游戏化待办应用 | **核心理念**：理解我、帮助我、不评判我
**技术栈**：React 18 + FastAPI + PostgreSQL 17
**当前阶段**：开发 W1 | **下一步**：数据库 Schema 设计

---

## 启动检查清单

1. ✅ 读取 `docs/progress.md` - 了解当前进度和任务状态
2. ✅ 读取 `docs/requirements/requirements_document_v1.md` - 回顾核心需求
3. ✅ 确认当前任务状态（⏳ 待开始 / 🔄 进行中 / ✅ 已完成）
4. ✅ 检查是否有阻塞项需要处理
5. ✅ 向用户简要汇报当前进度，确认下一步行动

---

## 必加载文档

### 🔴 P0 - 每次启动必须加载（最高优先级）

- `docs/progress.md` - **项目进度、任务状态、阻塞风险**（动态更新）
- `docs/requirements/requirements_document_v1.md` - **总体目标和功能需求**（静态）

### 🟡 P1 - 根据任务类型加载（中优先级）

**智能加载规则**：
- **前端开发任务** → `docs/meetings/phase_01_planning/discussions/frontend_design.md`（前端设计决策）
- **后端开发任务** → `docs/meetings/phase_01_planning/discussions/technical_architecture.md`（技术架构决策）
- **AI 集成任务** → `docs/design/plan_start_01.md`（游戏化机制详解）
- **团队协作任务** → `docs/requirements/team_organization_meeting_plan.md`（团队角色职责）

### 🟢 P2 - 需要时加载（低优先级）

- `docs/requirements/discussion_record_01.md` - 第一次多角色讨论会
- `docs/requirements/discussion_record_02_longterm_learning.md` - 第二次讨论会

---

## 常见场景处理指南

### 场景 1：领取新任务

```
1. 查看 docs/progress.md 任务状态
2. 选择状态为 ⏳ 的任务
3. 更新状态为 🔄 进行中
4. 根据任务类型加载相关文档（见"智能加载规则"）
5. 开始执行
```

### 场景 2：完成任务

```
1. 更新 docs/progress.md 任务状态为 ✅
2. 更新"最近更新记录"和"最后更新"时间戳
3. 检查是否有依赖此任务的其他任务可以开始
4. 向用户报告完成情况
5. 询问下一步操作
```

### 场景 3：遇到阻塞

```
1. 在 docs/progress.md 添加新的阻塞项
2. 标注影响范围和紧急程度
3. 提出可能的解决方案
4. 等待用户决策
```

### 场景 4：发起讨论会

```
1. 按照 Agent Team 模式启动（见下方规范）
2. 并行启动所有相关角色的 Agent
3. 实时交互和讨论
4. 生成 docs/meetings/phase_XX_xxx/conclusion.md
5. 更新 docs/progress.md
```

---

## Agent Team 模式规范

**强制规则**：所有讨论会必须使用 Agent Team 模式

### 核心流程

```
1. 并行启动阶段
   - 主持人明确议题和参与角色
   - 所有 Agent 同时启动，各自联网搜索权威资料

2. 实时交互阶段
   - 各 Agent 实时输出搜索结果和观点
   - 看到其他 agent 的输出，立即响应和调整
   - 形成真正的讨论，而非串行发言

3. 收敛阶段
   - 主持人总结关键决策
   - 记录人生成会议结论文档
   - 更新 docs/progress.md
```

### Agent 行为准则

**每个 Agent 必须**：
1. **独立搜索** - 根据角色职责，主动联网查询权威资料
2. **实时响应** - 看到其他 agent 的输出，立即判断是否需要调整自己的观点
3. **交叉引用** - 引用其他 agent 的观点，形成真正的对话
4. **角色视角** - 始终从自己角色的专业视角发言

**详细指南**：见 `docs/agent_team_guide.md`

---

## Claude Code 行为规范

### 任务完成后的强制操作

**每次完成一个任务后，必须执行**：

1. ✅ **更新 `docs/progress.md`**
   - 将任务状态从 ⏳/🔄 改为 ✅
   - 更新"最近更新记录"
   - 更新"最后更新"时间戳

2. ✅ **检查依赖任务**
   - 确认是否有其他任务可以开始
   - 如果有，更新它们的状态为 🔄 进行中

3. ✅ **检查阻塞与风险**
   - 是否有阻塞项可以移到"已解决"？
   - 是否发现了新的风险？

### 发现阻塞或风险时

**立即更新 `docs/progress.md`**：
- 添加新的阻塞项或风险项
- 标注影响范围和紧急程度
- 提出可能的解决方案

### 阶段变更时

**更新 `docs/progress.md`**：
- 更新"当前阶段"
- 更新"下一步"任务
- 添加阶段变更记录

---

## 技术决策摘要

### 技术栈（详情见 `docs/meetings/phase_01_planning/conclusion.md`）
- 前端：React 18 + TypeScript + Zustand + Framer Motion
- 后端：Python 3.11 + FastAPI + SQLAlchemy 2.0
- 数据库：PostgreSQL 17 + TimescaleDB 2.13
- CI/CD：Jenkins + Docker Compose

### 架构原则
- 单一数据库，无 Redis（使用 PG 内置缓存）
- AI 是建议者，用户有最终编辑权
- 所有文案必须通过"非评判性"检查

---

## 开发工作流

### Git 分支
```
main ← develop ← feature/*
```

### 提交规范
- `feat:` 新功能 | `fix:` 修复 | `docs:` 文档 | `refactor:` 重构

### 质量门禁
- 单元测试覆盖率 > 80%
- PR 需 CI 通过 + 1 人审查

---

## 核心设计原则

### 产品理念（详见 `docs/requirements/requirements_document_v1.md`）

1. **理解我、帮助我、不评判我** - 所有文案、交互、反馈必须通过此检查
2. **数据服务于理解，而非焦虑** - 强调"发现"而非"问题"
3. **提供选择权** - 游戏/专业模式切换、极简模式可选
4. **AI 是建议者，不是命令者** - 用户有最终编辑权

### 文案审核清单

所有用户可见文案必须通过：
- [ ] 是否使用评判性语言？("你应该"、"你错了")
- [ ] 是否制造焦虑？("落后"、"逾期"、"警告")
- [ ] 是否提供可操作建议？
- [ ] 是否强调"发现"而非"问题"？
- [ ] 是否尊重用户选择权？

---

## 文档维护原则

### CLAUDE.md（本文档）
- **性质**：静态核心规范
- **更新频率**：极少（仅在核心规范变更时）
- **内容**：核心需求、工作流程、技术决策摘要

### docs/progress.md
- **性质**：动态项目进度
- **更新频率**：每次完成任务后
- **内容**：当前阶段、任务状态、阻塞风险

### docs/ 目录结构
- **详细说明**：见 `docs/directory_structure.md`
- **包含**：requirements/（业务需求）、design/（设计方案）、meetings/（会议记录）