# Docs 目录结构说明

> **用途**: 为 Claude Code 指明项目文档系统的组织结构

---

## 目录结构

```
docs/
├── progress.md                              # 📊 动态项目进度（每次完成任务后更新）
├── agent_team_guide.md                      # 🤖 Agent Team 模式详细指南
│
├── requirements/                            # 📋 业务需求分析
│   ├── requirements_document_v1.md          # 产品需求文档
│   ├── discussion_record_01.md              # 需求讨论记录 1
│   ├── discussion_record_02_longterm_learning.md  # 需求讨论记录 2
│   └── team_organization_meeting_plan.md    # 团队组织与会议计划
│
├── design/                                  # 🎨 设计方案
│   └── plan_start_01.md                     # 初始设计方案（游戏化机制详解）
│
└── meetings/                                # 📝 会议记录（按阶段组织）
    ├── phase_01_planning/                   # 阶段 1：项目规划阶段
    │   ├── conclusion.md                    # 阶段会议结论
    │   ├── discussions/                     # 讨论记录
    │   │   ├── technical_architecture.md    # 技术架构讨论
    │   │   └── frontend_design.md           # 前端设计讨论
    │   └── resources/                       # 本阶段会议资源
    │
    ├── phase_02_development/                # 阶段 2：开发阶段
    │   ├── conclusion.md                    # （待创建）
    │   ├── discussions/                     # 讨论记录
    │   └── resources/                       # 本阶段会议资源
    │
    └── resources/                           # 全局会议资源
        ├── templates/                       # 模板文件
        │   └── meeting_template.md          # 会议记录模板
        └── references/                      # 参考资料
            └── reference_links.md           # 参考链接汇总
```

---

## 目录职责说明

| 目录 | 职责 | 更新频率 |
|------|------|----------|
| `requirements/` | 业务需求分析相关文档 | 按需更新 |
| `design/` | 设计方案和技术设计文档 | 按需更新 |
| `meetings/` | 会议记录，按项目阶段组织 | 每次会议后更新 |
| `progress.md` | 项目进度、任务状态、阻塞风险 | 每次完成任务后更新 |
| `agent_team_guide.md` | Agent Team 模式详细指南 | 极少更新 |

---

**最后更新**: 2026-03-07