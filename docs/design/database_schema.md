# 数据库Schema设计

**设计日期**: 2026-03-07
**设计原则**: 最小化依赖，快速启动

---

## 📊 数据库架构概览

```
PostgreSQL (元数据) + 文件系统 (Markdown内容)
```

---

## 🗃️ 数据表设计

### 1. users 用户表

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nickname VARCHAR(100),
    avatar_url VARCHAR(500),
    xp INTEGER DEFAULT 0,                    -- 经验值
    level INTEGER DEFAULT 1,                  -- 等级
    streak_days INTEGER DEFAULT 0,            -- 连击天数
    last_active_date DATE,                    -- 最后活跃日期
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- 索引
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_xp ON users(xp DESC);
```

### 2. tasks 任务表（核心）

```sql
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- 基本信息
    title VARCHAR(255) NOT NULL,              -- 任务名称（四象限显示）
    description TEXT,                          -- 简短描述
    
    -- 四象限分类
    quadrant VARCHAR(30) NOT NULL CHECK (quadrant IN ('urgent_important', 'not_urgent_important', 'urgent_not_important', 'not_urgent_not_important')),
    
    -- 状态
    status VARCHAR(20) DEFAULT 'todo' CHECK (status IN ('todo', 'doing', 'done', 'archived')),
    priority INTEGER DEFAULT 0,                -- 优先级
    
    -- Markdown文件路径
    content_path VARCHAR(500) NOT NULL,        -- Markdown文件路径 (相对路径)
    
    -- 游戏化
    xp_reward INTEGER DEFAULT 0,               -- 完成奖励经验值
    difficulty INTEGER DEFAULT 1 CHECK (difficulty BETWEEN 1 AND 5),  -- 难度1-5
    
    -- 时间
    due_date DATE,                             -- 截止日期
    completed_at TIMESTAMP,                    -- 完成时间
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 元数据
    tags TEXT[],                               -- 标签数组
    estimated_minutes INTEGER,                 -- 预估时间（分钟）
    actual_minutes INTEGER                     -- 实际时间（分钟）
);

-- 索引
CREATE INDEX idx_tasks_user_id ON tasks(user_id);
CREATE INDEX idx_tasks_quadrant ON tasks(quadrant);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);
CREATE INDEX idx_tasks_tags ON tasks USING GIN(tags);
```

### 3. achievements 成就表

```sql
CREATE TABLE achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    achievement_type VARCHAR(50) NOT NULL,     -- 成就类型
    achievement_name VARCHAR(100) NOT NULL,    -- 成就名称
    description TEXT,                          -- 描述
    xp_bonus INTEGER DEFAULT 0,                -- 奖励经验值
    achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, achievement_type, achievement_name)
);

CREATE INDEX idx_achievements_user_id ON achievements(user_id);
CREATE INDEX idx_achievements_achieved_at ON achievements(achieved_at DESC);
```

### 4. user_behavior_logs 用户行为日志（游戏化统计）

```sql
CREATE TABLE user_behavior_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action_type VARCHAR(50) NOT NULL,          -- 行为类型 (task_created, task_completed, etc.)
    task_id UUID REFERENCES tasks(id) ON DELETE SET NULL,
    xp_earned INTEGER DEFAULT 0,               -- 获得的经验值
    metadata JSONB,                            -- 额外元数据
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 索引
CREATE INDEX idx_behavior_logs_user_id ON user_behavior_logs(user_id);
CREATE INDEX idx_behavior_logs_created_at ON user_behavior_logs(created_at DESC);
CREATE INDEX idx_behavior_logs_action_type ON user_behavior_logs(action_type);
```

### 5. daily_metrics 每日指标（统计分析）

```sql
CREATE TABLE daily_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    
    -- 任务统计
    tasks_created INTEGER DEFAULT 0,
    tasks_completed INTEGER DEFAULT 0,
    
    -- 四象限分布
    urgent_important_count INTEGER DEFAULT 0,
    not_urgent_important_count INTEGER DEFAULT 0,
    urgent_not_important_count INTEGER DEFAULT 0,
    not_urgent_not_important_count INTEGER DEFAULT 0,
    
    -- 游戏化
    xp_earned INTEGER DEFAULT 0,
    streak_days INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, date)
);

CREATE INDEX idx_daily_metrics_user_date ON daily_metrics(user_id, date DESC);
```

---

## 📁 文件系统存储结构

### 任务Markdown文档

```
data/
└── tasks/
    ├── {user_id}/
    │   ├── {task_id_1}.md
    │   ├── {task_id_2}.md
    │   └── images/
    │       ├── {image_id_1}.png
    │       └── {image_id_2}.jpg
    └── templates/
        └── default_task.md
```

### Markdown文档示例

**文件**: `data/tasks/{user_id}/{task_id}.md`

```markdown
# 任务标题

## 任务描述
这是一个示例任务描述。

## 详细内容

### 背景
- 为什么需要做这个任务
- 背景信息

### 行动计划
1. 第一步：做什么
2. 第二步：做什么
3. 第三步：做什么

### 注意事项
- ⚠️ 注意点1
- ⚠️ 注意点2

## 相关资源
- [链接1](https://example.com)
- [链接2](https://example.com)

## 截图
![示例图片](./images/screenshot.png)

## Checklist
- [x] 已完成的事项
- [ ] 未完成的事项
- [ ] 未完成的事项
```

---

## 🔄 数据流设计

### 创建任务流程

```
1. 用户在前端填写任务信息
   ├─ 任务名称（必填）
   ├─ 四象限分类（必填）
   ├─ 截止日期（可选）
   └─ Markdown内容（可选，默认使用模板）

2. 前端发送请求到后端
   POST /api/tasks
   {
     "title": "任务名称",
     "quadrant": "urgent_important",
     "due_date": "2026-03-10",
     "content": "# 任务标题\n\n内容..."
   }

3. 后端处理
   ├─ 生成 task_id (UUID)
   ├─ 创建Markdown文件: data/tasks/{user_id}/{task_id}.md
   ├─ 写入Markdown内容
   ├─ 插入数据库记录
   │  - id: {task_id}
   │  - title: "任务名称"
   │  - quadrant: "urgent_important"
   │  - content_path: "data/tasks/{user_id}/{task_id}.md"
   │  - ...
   └─ 返回任务信息给前端
```

### 查看任务详情流程

```
1. 用户在四象限视图点击任务名称

2. 前端发送请求
   GET /api/tasks/{task_id}

3. 后端返回任务元数据
   {
     "id": "uuid",
     "title": "任务名称",
     "quadrant": "urgent_important",
     "status": "todo",
     "content_path": "data/tasks/{user_id}/{task_id}.md",
     ...
   }

4. 前端发送第二个请求获取内容
   GET /api/tasks/{task_id}/content

5. 后端读取Markdown文件
   ├─ 打开文件: data/tasks/{user_id}/{task_id}.md
   ├─ 读取内容
   └─ 返回Markdown文本
   {
     "content": "# 任务标题\n\n内容..."
   }

6. 前端渲染Markdown预览
   └─ 使用 markdown-it 渲染HTML
```

### 编辑任务流程

```
1. 用户点击"编辑"按钮

2. 前端加载Markdown编辑器
   ├─ 显示原始Markdown文本（可编辑）
   └─ 右侧实时预览

3. 用户编辑完成，点击"保存"

4. 前端发送请求
   PUT /api/tasks/{task_id}/content
   {
     "content": "更新后的Markdown内容"
   }

5. 后端处理
   ├─ 覆盖写入Markdown文件
   ├─ 更新数据库 updated_at 字段
   └─ 返回成功响应

6. 前端切换回预览模式
```

---

## 🎯 四象限展示设计

### 前端组件结构

```vue
<template>
  <div class="task-matrix">
    <!-- 四象限网格 -->
    <div class="quadrant-grid">
      <div class="quadrant urgent-important">
        <h3>紧急且重要</h3>
        <div class="task-list">
          <div 
            v-for="task in urgentImportantTasks" 
            :key="task.id"
            class="task-item"
            @click="openTaskDetail(task.id)"
          >
            {{ task.title }}
          </div>
        </div>
      </div>
      
      <!-- 其他三个象限... -->
    </div>
    
    <!-- 任务详情弹窗 -->
    <TaskDetailDialog 
      v-if="showDetail"
      :task-id="selectedTaskId"
      @close="showDetail = false"
      @edit="openTaskEditor"
    />
    
    <!-- 任务编辑弹窗 -->
    <TaskEditorDialog 
      v-if="showEditor"
      :task-id="selectedTaskId"
      @close="showEditor = false"
      @save="handleTaskSaved"
    />
  </div>
</template>
```

### API接口设计

#### 获取四象限任务列表

```http
GET /api/tasks?quadrant=urgent_important&status=todo,doing

Response:
{
  "tasks": [
    {
      "id": "uuid-1",
      "title": "完成项目报告",
      "quadrant": "urgent_important",
      "status": "doing",
      "due_date": "2026-03-10",
      "xp_reward": 50,
      "created_at": "2026-03-07T10:00:00Z"
    },
    {
      "id": "uuid-2",
      "title": "回复重要邮件",
      "quadrant": "urgent_important",
      "status": "todo",
      "due_date": "2026-03-08",
      "xp_reward": 20,
      "created_at": "2026-03-07T09:00:00Z"
    }
  ],
  "total": 2
}
```

#### 获取任务详情

```http
GET /api/tasks/{task_id}

Response:
{
  "id": "uuid-1",
  "title": "完成项目报告",
  "description": "这是一个重要的项目报告...",
  "quadrant": "urgent_important",
  "status": "doing",
  "due_date": "2026-03-10",
  "xp_reward": 50,
  "difficulty": 3,
  "content_path": "data/tasks/user-123/task-uuid-1.md",
  "created_at": "2026-03-07T10:00:00Z",
  "updated_at": "2026-03-07T12:00:00Z"
}
```

#### 获取任务Markdown内容

```http
GET /api/tasks/{task_id}/content

Response:
{
  "content": "# 完成项目报告\n\n## 任务描述\n这是一个重要的项目报告，需要在本周完成。\n\n## 行动计划\n1. 收集数据\n2. 分析数据\n3. 撰写报告\n4. 审核修改\n\n## 注意事项\n- ⚠️ 注意格式规范\n- ⚠️ 需要领导审核\n\n## 相关资源\n- [项目文档](https://example.com/doc)\n\n## Checklist\n- [x] 收集数据\n- [ ] 分析数据\n- [ ] 撰写报告\n- [ ] 审核修改"
}
```

#### 更新任务Markdown内容

```http
PUT /api/tasks/{task_id}/content
Content-Type: application/json

{
  "content": "更新后的Markdown内容..."
}

Response:
{
  "success": true,
  "message": "任务内容已更新",
  "updated_at": "2026-03-07T15:00:00Z"
}
```

---

## 🔐 文件安全措施

### 1. 路径安全

```python
# 后端验证文件路径，防止路径遍历攻击
import os
from pathlib import Path

def get_task_file_path(user_id: str, task_id: str) -> Path:
    """安全地获取任务文件路径"""
    base_path = Path("data/tasks") / user_id
    file_path = base_path / f"{task_id}.md"
    
    # 验证路径是否在允许的范围内
    if not file_path.resolve().is_relative_to(base_path.resolve()):
        raise ValueError("Invalid file path")
    
    return file_path
```

### 2. 文件上传限制

```python
# 图片上传配置
ALLOWED_EXTENSIONS = {'.png', '.jpg', '.jpeg', '.gif', '.webp'}
MAX_FILE_SIZE = 5 * 1024 * 1024  # 5MB

def validate_image(file: UploadFile):
    # 检查文件扩展名
    ext = Path(file.filename).suffix.lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise ValueError(f"File type {ext} not allowed")
    
    # 检查文件大小
    file.file.seek(0, 2)  # 移动到文件末尾
    size = file.file.tell()
    file.file.seek(0)  # 重置指针
    
    if size > MAX_FILE_SIZE:
        raise ValueError(f"File size {size} exceeds limit {MAX_FILE_SIZE}")
```

### 3. Markdown内容过滤

```python
import bleach

ALLOWED_TAGS = [
    'p', 'br', 'strong', 'em', 'u', 's', 
    'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
    'ul', 'ol', 'li', 
    'blockquote', 'pre', 'code',
    'a', 'img',
    'table', 'thead', 'tbody', 'tr', 'th', 'td',
    'hr', 'div', 'span'
]

ALLOWED_ATTRIBUTES = {
    'a': ['href', 'title', 'target'],
    'img': ['src', 'alt', 'title', 'width', 'height'],
    'div': ['class'],
    'span': ['class'],
    'code': ['class'],
    'pre': ['class']
}

def sanitize_markdown(html_content: str) -> str:
    """清理Markdown渲染后的HTML，防止XSS攻击"""
    return bleach.clean(
        html_content,
        tags=ALLOWED_TAGS,
        attributes=ALLOWED_ATTRIBUTES,
        strip=True
    )
```

---

## 📝 下一步行动

1. ✅ 数据库Schema设计完成
2. ⏳ 创建Alembic迁移脚本
3. ⏳ 实现FastAPI后端API
4. ⏳ 实现Vue3前端界面
5. ⏳ 集成Markdown编辑器和预览

---

**设计者**: Claude Code
**审核人**: 待定
**状态**: ✅ 已完成
