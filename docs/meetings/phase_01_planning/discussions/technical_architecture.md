# 会议 1: 技术架构与选型 - 会议纪要

**会议日期**: 2026-03-07
**会议时间**: 10:00 - 11:30
**会议形式**: 线上会议
**主持人**: Alex Thompson (项目总监)
**记录员**: 陈小文 (会议记录员)

---

## 📋 会议信息

| 项目 | 详情 |
|------|------|
| 会议主题 | 技术架构与选型 |
| 主持人 | Alex Thompson |
| 参会人员 | David Kim, Michael Zhang, Kevin Nguyen, Chris Martinez |
| 记录人 | 陈小文 |
| 会议状态 | ✅ 已完成 |

---

## 会议目标

1. 确定前端技术栈
2. 确定后端技术栈
3. 确定数据库方案
4. 确定部署架构
5. 确定 CI/CD 流程
6. 形成 2-3 个完整方案供最终决策

---

## 约束条件确认

| 约束 | 详情 |
|------|------|
| 部署环境 | 本地部署 |
| 容器编排 | Docker Compose 单级架构 |
| 技术偏好 | 成熟方案优先 |
| CI/CD | 需要完整的持续集成/持续部署流程 |
| 运维支持 | 有专职运维人员 (Chris Martinez) |

---

## 讨论内容

### 1. 前端技术选型

**发言人**: David Kim (前端架构师)

**需求分析:**
- 丰富的动画效果 (任务完成、升级庆祝)
- 数据可视化 (图表、进度展示)
- 离线支持 (PWA)
- 游戏/专业模式切换

**提出方案:**

| 方案 | 技术栈 | 优势 | 劣势 |
|------|--------|------|------|
| A | React 18 + TypeScript + Zustand + Framer Motion | 生态最成熟，招聘容易 | 包体积较大 |
| B | Vue 3 + TypeScript + Pinia + GSAP | 开发效率高，性能好 | 生态相对较小 |
| C | Next.js 14 + React 18 | 全栈能力，SSR 支持 | 本地部署 SSR 优势不明显 |

**讨论结论:**
- 团队一致推荐 **方案 A (React 生态)**
- 理由：纯 SPA 更适合 Docker 部署，前后端分离职责清晰，React 生态最成熟风险最低

**最终前端技术栈:**
```
• React 18 + TypeScript
• Zustand (状态管理)
• Framer Motion (动画)
• Recharts (图表)
• TailwindCSS (样式)
• Vite (构建工具)
```

---

### 2. 后端技术选型

**发言人**: Michael Zhang (后端架构师)

**需求分析:**
- 任务 CRUD + 游戏化逻辑
- AI API 集成 (任务拆分、学习路径生成)
- 数据分析聚合
- 用户认证授权

**提出方案:**

| 方案 | 技术栈 | 优势 | 劣势 |
|------|--------|------|------|
| A | Python 3.11 + FastAPI | AI 集成最方便，开发效率高 | 性能略低于 Go |
| B | Node.js 20 + NestJS | 前后端同语言，人才复用 | AI 集成不如 Python 方便 |
| C | Go 1.22 + Gin | 性能最好，内存占用低 | AI 集成困难，开发效率较低 |

**讨论结论:**
- 团队一致推荐 **方案 A (Python + FastAPI)**
- 理由：AI 集成是产品核心功能，Python AI 生态最丰富；性能对于本地部署足够

**最终后端技术栈:**
```
• Python 3.11 + FastAPI
• SQLAlchemy 2.0 + Alembic (ORM/迁移)
• JWT + OAuth2 (认证)
• ARQ (异步任务 - Redis 队列)
• LangChain / 直接 API (AI 集成)
```

---

### 3. 数据库与数据存储

**发言人**: Kevin Nguyen (数据工程师)

**需求分析:**
- 结构化数据 (用户、任务、成就)
- 时间序列数据 (行为日志、指标历史)
- 缓存 (实时指标、会话状态)
- AI 向量存储 (可选)

**提出方案:**

| 方案 | 技术栈 | 优势 | 劣势 |
|------|--------|------|------|
| A | PostgreSQL + TimescaleDB + Redis + pgvector | 单一数据库运维简单，扩展丰富 | TimescaleDB 需要额外配置 |
| B | PostgreSQL + InfluxDB + Redis | 时序性能最好 | 运维复杂度高 |
| C | SQLite + Redis | 极简，资源占用低 | 并发性能有限，无时序支持 |

**讨论结论:**
- 团队推荐 **方案 A (PostgreSQL 全家桶)**
- 理由：单一数据库运维简单，TimescaleDB 作为 PG 扩展无缝集成，pgvector 支持未来 AI 向量检索

**最终数据库方案:**
```
• PostgreSQL 16 (主库 + TimescaleDB 扩展)
• Redis 7 (缓存 + 队列)
• pgvector (向量存储，可选)
```

---

### 4. CI/CD 与部署架构

**发言人**: Chris Martinez (DevOps 工程师)

**需求分析:**
- 完整 CI/CD 流程
- 本地部署支持
- Docker Compose 容器化
- 监控告警

**提出方案:**

| 方案 | 技术栈 | 优势 | 劣势 |
|------|--------|------|------|
| A | GitHub Actions + Docker Hub | 生态最成熟，配置简单 | 需要公网访问 GitHub |
| B | GitLab CI/CD | 完全本地化，一体化平台 | 需要自建 GitLab，资源占用大 |
| C | Gitea + Drone CI | 极简轻量，完全本地化 | 生态较小，配置相对复杂 |

**讨论结论:**
- 团队推荐 **方案 A (GitHub Actions)**
- 理由：生态最成熟，自托管 Runner 支持本地部署，配置简单

**CI/CD 流程:**
```
Push to main
    │
    ▼
┌─────────┐    ┌─────────┐    ┌─────────┐
│  Lint   │───▶│  Test   │───▶│  Build  │
│  Check  │    │  Suite  │    │  Docker │
└─────────┘    └─────────┘    └─────────┘
                               │
                               ▼
                       ┌─────────────┐
                       │   Deploy    │
                       │ (Self-hosted)│
                       └─────────────┘
```

**Docker Compose 服务列表:**
```yaml
services:
  frontend:      # React SPA (Nginx)
  backend:       # FastAPI
  postgres:      # PostgreSQL + TimescaleDB
  redis:         # Redis
  prometheus:    # 监控 (可选)
  grafana:       # 可视化 (可选)
  loki:          # 日志 (可选)
```

---

## 三个完整方案对比

### 方案 A: 成熟稳健型 ⭐ **(团队推荐)**

| 维度 | 技术选型 |
|------|----------|
| 前端 | React 18 + TypeScript + Zustand + Framer Motion + Recharts + TailwindCSS |
| 后端 | Python 3.11 + FastAPI + SQLAlchemy 2.0 + Alembic + ARQ |
| 数据库 | PostgreSQL 16 + TimescaleDB + Redis 7 + pgvector |
| AI 集成 | LangChain / 直接 API 调用 |
| CI/CD | GitHub Actions + Docker Hub + 自托管 Runner |
| 部署 | Docker Compose |
| 监控 | Prometheus + Grafana + Loki (可选) |

**优点:**
- 技术成熟度 ⭐⭐⭐⭐⭐
- AI 集成友好度 ⭐⭐⭐⭐⭐
- 开发效率 ⭐⭐⭐⭐⭐
- 人才储备 ⭐⭐⭐⭐⭐

**缺点:**
- 性能不如 Go 方案
- 需要 Python 和 JavaScript 两套技术栈

---

### 方案 B: 全栈 TypeScript 型

| 维度 | 技术选型 |
|------|----------|
| 前端 | React 18 + TypeScript + Zustand + Framer Motion |
| 后端 | Node.js 20 + NestJS + Prisma + Bull |
| 数据库 | PostgreSQL 16 + Redis 7 |
| AI 集成 | 直接 API 调用 |
| CI/CD | GitHub Actions |
| 部署 | Docker Compose |

**优点:**
- 前后端同语言 ⭐⭐⭐⭐⭐
- 开发效率高
- 人才复用

**缺点:**
- AI 集成不如 Python 方便
- 数据处理库较少

---

### 方案 C: 高性能型

| 维度 | 技术选型 |
|------|----------|
| 前端 | Vue 3 + TypeScript + Pinia + GSAP |
| 后端 | Go 1.22 + Gin + GORM + asynq |
| 数据库 | PostgreSQL 16 + TimescaleDB + Redis 7 |
| AI 集成 | Python 微服务 (独立 AI 服务) |
| CI/CD | GitHub Actions |
| 部署 | Docker Compose |

**优点:**
- 性能 ⭐⭐⭐⭐⭐
- 内存占用低
- 部署简单

**缺点:**
- AI 集成需要额外 Python 服务
- 开发效率较低
- 招聘相对难

---

## 方案对比总结表

| 维度 | 方案 A ⭐ | 方案 B | 方案 C |
|------|----------|--------|--------|
| 技术成熟度 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| AI 集成友好度 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| 开发效率 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| 性能 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 运维复杂度 | 中 | 低 | 高 |
| 人才储备 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| 社区支持 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 风险等级 | 低 | 低 | 中 |

---

## 最终推荐方案

**团队一致推荐: 方案 A - 成熟稳健型**

```
┌─────────────────────────────────────────────────────────┐
│  推荐方案：方案 A - 成熟稳健型                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  前端:                                                  │
│  • React 18 + TypeScript                                │
│  • Zustand (状态管理)                                   │
│  • Framer Motion (动画)                                 │
│  • Recharts (图表)                                      │
│  • TailwindCSS (样式)                                   │
│  • Vite (构建工具)                                      │
│                                                         │
│  后端:                                                  │
│  • Python 3.11 + FastAPI                                │
│  • SQLAlchemy 2.0 + Alembic (ORM/迁移)                  │
│  • JWT + OAuth2 (认证)                                  │
│  • Celery + PostgreSQL (异步任务队列)                    │
│  • LangChain (AI 集成 - 调用现有 LLM 接口)               │
│                                                         │
│  数据库:                                                │
│  • PostgreSQL 17 (主库 + TimescaleDB 扩展)              │
│  • 缓存: PG 内置缓存 + 应用层内存缓存（无需 Redis）      │
│  • pgvector (向量存储，可选)                             │
│                                                         │
│  CI/CD:                                                 │
│  • Jenkins (本地部署)                                   │
│  • Docker Compose                                       │
│                                                         │
│  部署:                                                  │
│  • Docker Compose                                       │
│  • 本地部署                                             │
│                                                         │
│  监控 (可选):                                           │
│  • Prometheus + Grafana                                 │
│  • Loki (日志)                                          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Docker Compose 架构图

```
┌─────────────────────────────────────────────────────────┐
│  Docker Compose 架构                                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐     ┌─────────────┐                   │
│  │  frontend   │────▶│   backend   │                   │
│  │  (Nginx)    │     │  (FastAPI)  │                   │
│  │  :80        │     │  :8000      │                   │
│  └─────────────┘     └──────┬──────┘                   │
│                             │                           │
│              ┌──────────────┴──────────────┐           │
│              │                             │           │
│              ▼                             ▼           │
│      ┌───────────┐                  ┌───────────┐      │
│      │ postgres  │                  │  Jenkins  │      │
│      │  :5432    │                  │  :8080    │      │
│      │ +Timescale│                  │  (CI/CD)  │      │
│      └───────────┘                  └───────────┘      │
│                                                         │
│  注: 无需 Redis，使用 PG 内置缓存 + 应用层内存缓存      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 关键决策点

### 决策 1: 前端框架
- **决策**: React 18 + TypeScript
- **理由**: 生态最成熟，动画支持好，招聘容易
- **反对意见**: 无

### 决策 2: 后端框架
- **决策**: Python 3.11 + FastAPI
- **理由**: AI 集成最方便，数据处理库丰富，开发效率高
- **反对意见**: 无

### 决策 3: 数据库
- **决策**: PostgreSQL 17 (仅 PG，无需 Redis)
- **理由**: 单一数据库运维最简单，使用 PG 内置缓存 + 应用层内存缓存
- **缓存方案**: PostgreSQL 缓存 + 应用层内存缓存（无需 Redis）
- **反对意见**: 无

### 决策 4: CI/CD
- **决策**: Jenkins
- **理由**: 成熟稳定，本地部署支持好，有专职运维支持
- **反对意见**: 无

### 决策 5: 部署方案
- **决策**: Docker Compose 本地部署
- **理由**: 符合项目约束，运维简单
- **反对意见**: 无

---

## 风险与缓解措施

| 风险 | 可能性 | 影响 | 缓解措施 |
|------|--------|------|----------|
| Python 性能瓶颈 | 低 | 中 | 本地部署用户量有限，性能足够；热点可单独用 Go 重写 |
| TimescaleDB 配置复杂 | 中 | 低 | Chris 负责配置，提前测试 |
| 前后端技术栈不同 | 低 | 中 | API 文档完善，接口规范统一 |
| LLM API 成本 | 中 | 中 | 使用轻量级模型 + 缓存，优化调用频率 |
| Jenkins 维护成本 | 低 | 中 | 有专职运维人员 Chris 支持 |
| 无 Redis 缓存性能 | 低 | 低 | PG 缓存 + 应用层内存足够 MVP 阶段使用 |

---

## 待确认事项

| 事项 | 负责人 | 截止日期 |
|------|--------|----------|
| 确认 PostgreSQL + TimescaleDB Docker 镜像 | Chris | 2026-03-08 |
| 确认 Jenkins 本地部署配置 | Chris | 2026-03-08 |
| AI 提示词设计与 LLM 接口对接 | Dr. Emily (提示词工程师) | 2026-03-10 |
| 数据库 Schema 详细设计 | Michael, Kevin | 2026-03-12 |

---

## AI 团队配置说明

| 角色 | 需求 | 说明 |
|------|------|------|
| 提示词工程师 | ✅ 需要 | Dr. Emily - 负责 AI 提示词设计、LLM 接口调用 |
| ML 工程师 | ❌ 不需要 | 直接调用现有 LLM 接口（如 Anthropic、OpenAI 等） |

**AI 集成方案**:
- 使用 LangChain 框架调用现有 LLM API
- 无需训练或部署自定义模型
- 重点在于提示词设计和输出处理

---

## 下一步行动

| 行动 | 负责人 | 截止日期 |
|------|--------|----------|
| 创建项目仓库和 Jenkins CI/CD 配置 | Chris | 2026-03-08 |
| 搭建前端项目脚手架 | David, Jessica | 2026-03-10 |
| 搭建后端项目脚手架 | Michael, Ryan | 2026-03-10 |
| 编写 Docker Compose 配置文件 | Chris | 2026-03-10 |
| 设计数据库 Schema | Michael, Kevin | 2026-03-12 |
| 准备会议 2: 前端设计与交互 | Sarah, Maya | 2026-03-12 |

---

## 附录

### 参考文档
- `requirements_document_v1.md` - 产品需求文档
- `team_organization_meeting_plan.md` - 团队组织与会议计划
- `plan_start_01.md` - 深度设计方案
- `discussion_record_01.md` - 第一次多角色讨论会记录
- `discussion_record_02_longterm_learning.md` - 第二次多角色讨论会记录

### 会议参与者反馈
- "方案 A 确实是最适合的选择，成熟稳定" - David
- "Python + FastAPI 对 AI 集成友好，开发效率高" - Michael
- "PostgreSQL + TimescaleDB 运维简单，配置我已经熟悉" - Chris
- "单一数据库方案数据一致性好管理" - Kevin

---

**会议结束时间**: 11:30
**下次会议**: 会议 2 - 前端设计与交互 (预计 2026-03-12)

**记录人**: 陈小文
**审核人**: Alex Thompson