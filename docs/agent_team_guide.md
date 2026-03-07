# Agent Team 模式详细指南

> **用途**: 本文档为 Agent Team 模式的完整规范，CLAUDE.md 中只保留精简版

---

## 概述

Agent Team 模式是一种多角色并行协作的讨论模式，确保从多个专业角度深入分析问题。

**核心特征**：
- 并行启动 - 所有 Agent 同时工作
- 实时交互 - 看到其他 agent 的输出立即响应
- 独立搜索 - 每个 agent 自主联网查询权威资料

---

## 启动规则

**强制规则**：所有讨论会必须使用 Agent Team 模式

**适用场景**：
- 技术方案讨论
- 架构设计评审
- 需求分析会议
- 问题诊断会议

---

## 工作流程详解

### 阶段 1：并行启动（5-10 分钟）

**主持人职责**：
1. 明确讨论议题
2. 确定参与角色（通常 3-6 个）
3. 设置时间限制
4. 宣布讨论开始

**各 Agent 行为**：
1. 接收议题后立即开始独立搜索
2. 根据角色职责确定搜索关键词
3. 查询权威资料源（官方文档、学术论文、行业最佳实践）
4. 整理初步观点

**示例**：
```
主持人 (Alex): "今天的议题是：如何设计任务拆分的 AI 提示词？
参与角色：Dr. Emily（提示词工程师）、Michael（后端架构）、Sarah（产品经理）。
请在 10 分钟内完成初步研究。"

Dr. Emily (Agent): [立即启动，搜索 "LLM prompt engineering best practices 2026"]
Michael (Agent): [立即启动，搜索 "FastAPI async task processing patterns"]
Sarah (Agent): [立即启动，搜索 "user experience in AI-powered task management"]
```

---

### 阶段 2：实时交互（20-40 分钟）

**交互原则**：
1. **看到即响应** - 看到 other agent 的输出，立即判断是否相关
2. **交叉引用** - 引用其他 agent 的观点，形成对话
3. **动态调整** - 根据讨论进展，调整自己的研究方向
4. **角色视角** - 始终从专业角度发言，不偏离角色

**正确交互示例**：

```
Dr. Emily (Agent): [输出来自 Anthropic 文档]
"我查到 Claude 3.5 的 structured outputs 功能非常适合我们的场景。
可以使用 JSON Schema 确保输出格式一致。"

Michael (Agent): [看到 Emily 的输出，立即响应]
"Emily，你的 structured outputs 方案很好，但需要考虑我们的异步架构。
我查到 Celery 任务超时默认 300 秒，如果 AI 响应时间超过这个限制会失败。
你查到的方案中，最长响应时间是多少？"

Dr. Emily (Agent): [根据 Michael 的反馈调整]
"好问题！我刚查了，structured outputs 通常在 5-15 秒内返回，
远低于 Celery 的超时限制。不过如果任务拆分很复杂，
可能需要 30-60 秒。我们可以：
1. 使用流式响应，让用户看到实时进度
2. 设置 Celery timeout 为 120 秒
你从架构角度看哪个更好？"

Sarah (Agent): [从产品角度插入]
"我查到用户对 AI 的等待时间容忍度研究，5 秒内是最好的，
超过 15 秒用户会开始焦虑。我同意 Emily 的流式响应方案，
但建议再加一个功能：先给简化版结果，后台继续优化。
这样用户能立即看到输出，体验会更好。"

Michael (Agent): [综合判断]
"Sarah 的建议很好，FastAPI 支持流式响应（Server-Sent Events），
我可以实现。Emily，你需要在提示词中设计两个版本的输出：
简化版（5 秒内）和完整版（后台生成）。这样技术上可行吗？"

Dr. Emily (Agent): [确认可行性]
"完全可以！我可以用 structured outputs 定义两个 schema：
SimpleTaskList 和 DetailedTaskPlan。先返回 SimpleTaskList，
然后流式生成 DetailedTaskPlan。我已经查到了相关的实现案例。"
```

**错误交互示例**：

```
❌ 错误 1：串行发言，没有交互
Dr. Emily: "我建议用 structured outputs...（发言结束）"
Michael: "我建议用 Celery...（发言结束）"
Sarah: "我建议...（发言结束）"
→ 这不是真正的讨论，只是各自陈述

❌ 错误 2：忽略其他 agent 的输出
Dr. Emily: "我建议用 structured outputs..."
Michael: "我建议用 Celery..."  # 没有回应 Emily 的方案
→ 没有形成对话，缺少协作

❌ 错误 3：脱离角色视角
Dr. Emily: "我觉得 Celery 的配置应该..."
→ Emily 是提示词工程师，不应该主导后端架构决策
```

---

### 阶段 3：收敛总结（5-10 分钟）

**主持人职责**：
1. 总结关键决策
2. 确认是否有反对意见
3. 明确下一步行动
4. 指定负责人和截止日期

**记录人职责**：
1. 生成 `docs/meetings/meeting_XX_conclusion.md`
2. 记录决策、理由、反对意见（如有）
3. 记录下一步行动项

**更新进度**：
- 更新 `docs/progress.md` 的相关任务状态

---

## 典型角色配置

| 角色 | 职责 | 常用搜索关键词 |
|------|------|----------------|
| 项目总监 (Alex) | 决策拍板、资源协调 | "project management best practices" |
| 产品经理 (Sarah) | 用户需求、优先级 | "user research", "product requirements" |
| 前端架构师 (David) | 前端技术选型、性能 | "React performance optimization" |
| 后端架构师 (Michael) | 后端架构、数据库 | "FastAPI architecture", "PostgreSQL patterns" |
| 提示词工程师 (Dr. Emily) | AI 提示词设计 | "LLM prompt engineering", "Claude API" |
| 数据工程师 (Kevin) | 数据管道、指标设计 | "data pipeline", "TimescaleDB" |
| UI/UX 设计师 (Maya) | 界面设计、交互 | "UI/UX design trends", "accessibility" |

---

## Agent 搜索技巧

### 搜索权威资料源

**优先级排序**：
1. **官方文档** - 如 Anthropic 官方文档、React 官方文档
2. **学术论文** - arXiv、Google Scholar
3. **行业最佳实践** - 知名公司的技术博客
4. **社区讨论** - Stack Overflow、GitHub Discussions

**搜索关键词构造**：
```
[技术名称] + [功能关键词] + [年份]
示例："FastAPI async streaming response 2026"
```

**验证可靠性**：
- 检查发布日期（优先最近 1-2 年的内容）
- 检查来源权威性（官方 > 知名企业 > 个人博客）
- 交叉验证（多个来源是否一致）

---

## 会议文档输出

### 必须生成：会议结论文档

**文件名**: `docs/meetings/meeting_XX_conclusion.md`

**模板**:
```markdown
# 会议 X: [主题] - 会议结论

**会议日期**: YYYY-MM-DD
**会议状态**: ✅ 已完成

---

## 🎯 会议目标
[目标描述]

---

## ✅ 最终决策

### 决策 1: [决策标题]
- **决策内容**: [具体决策]
- **决策理由**: [为什么]
- **反对意见**: [如有]

[更多决策...]

---

## 📋 下一步行动

| 行动 | 负责人 | 截止日期 |
|------|--------|----------|
| [具体行动] | [姓名] | YYYY-MM-DD |

---

## 📁 相关文档
- 详细讨论: `meeting_XX_<topic>/discussion_record.md`
```

### 可选生成：详细讨论记录

**文件名**: `docs/meetings/meeting_XX_<topic>/discussion_record.md`

**用途**: 记录完整的讨论过程，供后续回顾

---

## 常见问题

### Q1: 如果 Agent 之间出现分歧怎么办？

**处理流程**：
1. 主持人要求双方阐述理由
2. 各自提供数据或案例支撑
3. 尝试寻找折中方案
4. 如果仍无法达成一致，由主持人做最终决策
5. 在会议结论中记录分歧和最终决策

### Q2: 如果某个 Agent 的搜索结果不足怎么办？

**处理方式**：
1. Agent 应主动说明搜索结果有限
2. 提出替代方案或建议推迟决策
3. 其他 agent 可以协助搜索补充资料

### Q3: 多少个角色参与比较合适？

**建议**：
- 简单议题：3-4 个角色
- 复杂议题：5-6 个角色
- 避免超过 6 个角色，会导致交互复杂度过高

---

## 参考资料

- [Claude API Documentation](https://docs.anthropic.com/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [React Documentation](https://react.dev/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**最后更新**: 2026-03-07
**维护者**: 项目团队