# 技术栈最终决策文档

**决策日期**: 2026-03-07
**决策状态**: ✅ 已确认
**决策人**: 用户 + Claude Code

---

## 📋 核心决策原则

1. **快速启动优先** - 最小化依赖，快速搭建MVP
2. **技术栈简化** - 不引入Redis、MQ等第三方组件
3. **用户体验友好** - Markdown支持，实时预览
4. **易于维护** - 技术栈成熟，文档完善

---

## 🎯 最终技术栈

### 前端技术栈

| 技术组件 | 选型 | 版本 | 理由 |
|---------|------|------|------|
| **框架** | Vue 3 | 3.4+ | 用户指定，学习曲线平缓，开发效率高 |
| **语言** | TypeScript | 5.0+ | 类型安全，减少运行时错误 |
| **构建工具** | Vite | 5.0+ | 极速开发体验，热更新快 |
| **UI组件库** | Element Plus | 2.5+ | Vue生态最成熟，组件丰富 |
| **状态管理** | Pinia | 2.1+ | Vue官方推荐，API简洁 |
| **路由** | Vue Router | 4.2+ | Vue官方路由方案 |
| **Markdown渲染** | markdown-it | 14.0+ | 轻量级，插件丰富 |
| **Markdown编辑器** | v-md-editor | 2.3+ | Vue3支持，实时预览 |
| **图表库** | ECharts | 5.5+ | 功能强大，Vue-ECharts集成好 |
| **动画** | Vue Transition + CSS | - | 原生支持，足够使用 |
| **HTTP客户端** | Axios | 1.6+ | 成熟稳定，拦截器强大 |
| **样式方案** | UnoCSS | 0.58+ | 原子化CSS，性能优秀 |

### 后端技术栈

| 技术组件 | 选型 | 版本 | 理由 |
|---------|------|------|------|
| **语言** | Python | 3.11+ | 用户指定，AI集成友好 |
| **框架** | FastAPI | 0.109+ | 轻量级，高性能，自动API文档 |
| **ORM** | SQLAlchemy | 2.0+ | Python最成熟的ORM |
| **数据库** | PostgreSQL | 15+ | 用户指定，JSONB支持好 |
| **数据库驱动** | asyncpg | 0.29+ | 异步PostgreSQL驱动 |
| **数据验证** | Pydantic | 2.5+ | FastAPI内置，类型安全 |
| **认证** | JWT | - | 无状态认证，无需Redis |
| **文件存储** | 本地文件系统 | - | 任务Markdown文档存储 |
| **API文档** | OpenAPI/Swagger | - | FastAPI自动生成 |
| **异步支持** | asyncio | - | Python原生异步 |

### 数据库设计

| 存储类型 | 用途 | 理由 |
|---------|------|------|
| **PostgreSQL** | 任务元数据 | 结构化查询，事务支持 |
| **文件系统** | 任务Markdown文档 | 灵活编辑，版本控制友好 |

---

## 🚫 明确不引入的组件

| 组件 | 不引入理由 | 替代方案 |
|------|-----------|---------|
| **Redis** | 简化架构，减少依赖 | PostgreSQL缓存、内存缓存 |
| **消息队列** | MVP阶段不需要异步处理 | 同步处理、定时任务 |
| **Elasticsearch** | 搜索需求简单 | PostgreSQL全文搜索 |
| **微服务架构** | 团队规模小，单体足够 | 模块化单体架构 |

---

## 🏗️ 核心架构设计

### 1. 任务存储架构

```
任务数据 = PostgreSQL元数据 + 文件系统Markdown文档

PostgreSQL (元数据):
- 任务ID
- 任务名称
- 四象限分类 (urgent/important)
- 创建时间、更新时间
- 状态 (todo/doing/done)
- 文件路径 (指向MD文档)
- 其他索引字段

文件系统 (内容):
/data/tasks/
  ├── {task_id_1}.md
  ├── {task_id_2}.md
  └── {task_id_3}.md
```

**优势**：
- ✅ Markdown编辑灵活，支持富文本、代码块、图片
- ✅ 版本控制友好，可使用Git追踪变更
- ✅ 数据库查询高效，索引、筛选快速
- ✅ 备份简单，文件 + 数据库导出

### 2. 四象限展示设计

```
┌─────────────────┬─────────────────┐
│  紧急且重要      │  不紧急但重要    │
│  (Urgent)       │  (Important)    │
│                 │                 │
│  - 任务名称1    │  - 任务名称5    │
│  - 任务名称2    │  - 任务名称6    │
│  - 任务名称3    │  - 任务名称7    │
│                 │                 │
├─────────────────┼─────────────────┤
│  紧急但不重要    │  不紧急不重要    │
│  (Urgent)       │  (Not Urgent)   │
│                 │                 │
│  - 任务名称4    │  - 任务名称8    │
│                 │  - 任务名称9    │
└─────────────────┴─────────────────┘
```

**交互设计**：
1. 四象限视图中只显示**任务名称**（简洁）
2. 点击任务名称 → 打开详情弹窗
3. 详情弹窗展示：
   - Markdown预览（只读模式）
   - 编辑按钮 → 切换到编辑模式
   - 编辑模式：Markdown编辑器 + 实时预览

### 3. Markdown编辑与预览

**技术方案**：
- **编辑器**: v-md-editor（Vue3支持，实时预览）
- **渲染器**: markdown-it（轻量级，插件丰富）
- **功能支持**:
  - ✅ 实时预览
  - ✅ 代码高亮
  - ✅ 表格支持
  - ✅ 图片上传（保存到服务器）
  - ✅ 任务清单（checkbox）
  - ✅ 快捷键操作

**编辑流程**：
```
用户点击"编辑" 
  → 加载MD文档内容
  → 打开Markdown编辑器
  → 左侧编辑，右侧实时预览
  → 点击"保存"
  → 保存到文件系统
  → 更新数据库元数据
  → 关闭编辑器
  → 返回详情预览
```

---

## 📊 API 设计原则

### RESTful API 设计

```
GET    /api/tasks              # 获取任务列表（支持四象限筛选）
GET    /api/tasks/{id}         # 获取任务元数据
GET    /api/tasks/{id}/content # 获取任务Markdown内容
POST   /api/tasks              # 创建任务（同时创建MD文件）
PUT    /api/tasks/{id}         # 更新任务元数据
PUT    /api/tasks/{id}/content # 更新任务Markdown内容
DELETE /api/tasks/{id}         # 删除任务（同时删除MD文件）
```

### 文件上传API

```
POST   /api/upload/image       # 上传图片（Markdown中引用）
```

---

## 🎨 前端页面结构

```
/
├── /dashboard          # 仪表盘（统计概览）
├── /matrix             # 四象限视图（主页面）
├── /tasks/:id          # 任务详情（Markdown预览）
├── /tasks/:id/edit     # 任务编辑（Markdown编辑器）
├── /profile            # 用户设置
└── /login              # 登录页
```

---

## 🔧 开发工具链

### 前端开发工具

```json
{
  "packageManager": "pnpm",
  "bundler": "Vite",
  "linter": "ESLint + Airbnb",
  "formatter": "Prettier",
  "test": "Vitest + Vue Test Utils",
  "e2e": "Playwright"
}
```

### 后端开发工具

```toml
[tool.poetry]
python = "^3.11"

[tool.black]
line-length = 88

[tool.ruff]
select = ["E", "F", "I"]

[tool.pytest]
testpaths = ["tests"]
```

---

## 📦 项目目录结构

```
todolist/
├── frontend/                 # 前端项目
│   ├── src/
│   │   ├── views/           # 页面
│   │   ├── components/      # 组件
│   │   ├── stores/          # Pinia状态管理
│   │   ├── api/             # API调用
│   │   ├── utils/           # 工具函数
│   │   └── assets/          # 静态资源
│   ├── public/              # 公共资源
│   └── package.json
│
├── backend/                  # 后端项目
│   ├── app/
│   │   ├── api/             # API路由
│   │   ├── models/          # 数据库模型
│   │   ├── schemas/         # Pydantic模型
│   │   ├── services/        # 业务逻辑
│   │   └── main.py          # FastAPI入口
│   ├── tests/               # 测试
│   ├── alembic/             # 数据库迁移
│   └── pyproject.toml
│
├── data/                     # 数据存储
│   └── tasks/               # 任务Markdown文档
│       ├── {uuid}.md
│       └── images/          # 上传的图片
│
└── docs/                     # 项目文档
    ├── design/              # 设计文档
    ├── requirements/        # 需求文档
    └── meetings/            # 会议记录
```

---

## 🚀 快速启动流程

### 1. 环境准备

```bash
# 安装PostgreSQL 15
sudo apt install postgresql-15

# 创建数据库
createdb todolist

# 安装Python 3.11+
pyenv install 3.11.7

# 安装Node.js 20+
nvm install 20
```

### 2. 后端启动

```bash
cd backend

# 安装依赖
poetry install

# 配置环境变量
cp .env.example .env
# 编辑 .env，配置数据库连接

# 运行数据库迁移
alembic upgrade head

# 启动开发服务器
uvicorn app.main:app --reload
```

### 3. 前端启动

```bash
cd frontend

# 安装依赖
pnpm install

# 启动开发服务器
pnpm dev
```

### 4. 访问应用

```
前端: http://localhost:5173
后端: http://localhost:8000
API文档: http://localhost:8000/docs
```

---

## 🎯 MVP功能清单

### Phase 1: 核心功能（2周）

- ✅ 用户注册/登录
- ✅ 四象限任务展示
- ✅ 任务创建（Markdown编辑器）
- ✅ 任务详情查看（Markdown预览）
- ✅ 任务编辑（Markdown编辑器）
- ✅ 任务删除
- ✅ 四象限分类拖拽调整

### Phase 2: 游戏化功能（2周）

- ⏳ XP经验值系统
- ⏳ 连击系统
- ⏳ 成就系统
- ⏳ 数据统计图表

### Phase 3: AI功能（2周）

- ⏳ AI任务拆分
- ⏳ 智能建议

---

## 📈 性能优化策略

### 前端优化

1. **代码分割**: 路由级别懒加载
2. **图片优化**: 压缩 + WebP格式
3. **缓存策略**: 本地存储任务列表
4. **虚拟滚动**: 大量任务时使用虚拟列表

### 后端优化

1. **数据库索引**: 四象限字段、状态字段建立索引
2. **连接池**: 使用asyncpg连接池
3. **分页查询**: 任务列表分页
4. **缓存策略**: Python内存缓存（字典或functools.lru_cache）

---

## 🔐 安全措施

1. **JWT认证**: 无状态认证，不依赖Redis
2. **密码加密**: bcrypt加密
3. **SQL注入防护**: SQLAlchemy参数化查询
4. **XSS防护**: Markdown渲染时过滤危险标签
5. **文件上传限制**: 文件类型、大小限制
6. **CORS配置**: 限制允许的域名

---

## 📝 文档更新记录

| 日期 | 更新内容 | 操作者 |
|------|----------|--------|
| 2026-03-07 | 创建技术栈最终决策文档 | Claude Code |
| 2026-03-07 | 确认Vue3 + Python + PostgreSQL方案 | 用户 |

---

**审核人**: 用户
**状态**: ✅ 已确认
**下一步**: 设计数据库Schema
