# API 接口规范文档

**文档版本**: v1.0
**创建日期**: 2026-03-08
**负责人**: Michael Zhang (后端架构师)
**状态**: 初稿

---

## 文档修订记录

| 版本 | 日期 | 修改人 | 修改内容 |
|------|------|--------|----------|
| v1.0 | 2026-03-08 | Michael Zhang | 初始版本 |

---

## 目录

1. [API 设计原则](#1-api-设计原则)
2. [通用规范](#2-通用规范)
3. [认证与授权](#3-认证与授权)
4. [用户模块 API](#4-用户模块-api)
5. [任务模块 API](#5-任务模块-api)
6. [游戏化系统 API](#6-游戏化系统-api)
7. [数据分析 API](#7-数据分析-api)
8. [AI 辅助 API](#8-ai-辅助-api)
9. [错误码定义](#9-错误码定义)

---

## 1. API 设计原则

### 1.1 RESTful 设计原则

- ✅ 使用标准 HTTP 方法（GET, POST, PUT, DELETE）
- ✅ 资源命名使用复数形式（/tasks, /users）
- ✅ 使用 HTTP 状态码表示操作结果
- ✅ 无状态设计，每次请求包含所有必要信息
- ✅ 支持过滤、排序、分页

### 1.2 URL 规范

```
基础URL: http://localhost:8000/api/v1

资源命名规则:
- 使用小写字母
- 使用连字符分隔单词
- 使用复数形式
- 避免嵌套超过 2 层

示例:
GET    /api/v1/users                 # 获取用户列表
GET    /api/v1/users/{id}            # 获取单个用户
POST   /api/v1/users                 # 创建用户
PUT    /api/v1/users/{id}            # 更新用户
DELETE /api/v1/users/{id}            # 删除用户
GET    /api/v1/users/{id}/tasks      # 获取用户的任务列表
```

### 1.3 版本控制

- 使用 URL 路径版本控制：`/api/v1/`
- 主版本号变更表示不兼容的 API 变更
- 次版本号变更表示向后兼容的功能新增

---

## 2. 通用规范

### 2.1 请求格式

**Content-Type**: `application/json`

**请求头**:
```
Content-Type: application/json
Authorization: Bearer {token}  # 需要认证的接口
```

### 2.2 响应格式

**成功响应**:
```json
{
  "success": true,
  "data": { ... },
  "message": "操作成功"
}
```

**失败响应**:
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "错误描述",
    "details": { ... }  // 可选
  }
}
```

### 2.3 分页参数

**请求参数**:
```
GET /api/v1/tasks?page=1&page_size=20&sort=created_at&order=desc
```

**响应格式**:
```json
{
  "success": true,
  "data": {
    "items": [ ... ],
    "pagination": {
      "page": 1,
      "page_size": 20,
      "total": 100,
      "total_pages": 5
    }
  }
}
```

### 2.4 过滤与排序

**过滤**:
```
GET /api/v1/tasks?status=todo&quadrant=1&difficulty=3
```

**排序**:
```
GET /api/v1/tasks?sort=created_at&order=desc
```

**字段选择**:
```
GET /api/v1/tasks?fields=id,title,status
```

---

## 3. 认证与授权

### 3.1 认证方式

- **JWT (JSON Web Token)**
- Token 有效期：15 分钟
- Refresh Token 有效期：7 天

### 3.2 认证流程

```
1. 用户登录 → POST /api/v1/auth/login
2. 返回 access_token 和 refresh_token
3. 后续请求在 Header 中携带 access_token
4. Token 过期后使用 refresh_token 刷新
```

### 3.3 认证 API

#### POST /api/v1/auth/register

**描述**: 用户注册

**请求体**:
```json
{
  "username": "string",      // 必填，3-50字符
  "email": "string",         // 必填，有效邮箱格式
  "password": "string"       // 必填，至少8位，包含大小写字母和数字
}
```

**响应**: 201 Created
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "username": "string",
      "email": "string",
      "created_at": "2026-03-08T00:00:00Z"
    },
    "token": {
      "access_token": "string",
      "refresh_token": "string",
      "expires_in": 900  // 15分钟（秒）
    }
  },
  "message": "注册成功"
}
```

---

#### POST /api/v1/auth/login

**描述**: 用户登录

**请求体**:
```json
{
  "email": "string",
  "password": "string"
}
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "username": "string",
      "email": "string",
      "xp": 0,
      "level": 1,
      "streak_days": 0
    },
    "token": {
      "access_token": "string",
      "refresh_token": "string",
      "expires_in": 900
    }
  },
  "message": "登录成功"
}
```

---

#### POST /api/v1/auth/refresh

**描述**: 刷新访问令牌

**请求体**:
```json
{
  "refresh_token": "string"
}
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "access_token": "string",
    "expires_in": 900
  },
  "message": "Token刷新成功"
}
```

---

#### POST /api/v1/auth/logout

**描述**: 用户登出

**认证**: 需要

**响应**: 200 OK
```json
{
  "success": true,
  "message": "登出成功"
}
```

---

## 4. 用户模块 API

### 4.1 用户信息管理

#### GET /api/v1/users/me

**描述**: 获取当前用户信息

**认证**: 需要

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "username": "string",
    "email": "string",
    "nickname": "string",
    "avatar_url": "string",
    "xp": 500,
    "level": 5,
    "streak_days": 7,
    "last_active_date": "2026-03-08",
    "created_at": "2026-03-01T00:00:00Z",
    "mode": "game"  // "game" 或 "professional"
  }
}
```

---

#### PUT /api/v1/users/me

**描述**: 更新当前用户信息

**认证**: 需要

**请求体**:
```json
{
  "nickname": "string",      // 可选
  "avatar_url": "string",    // 可选
  "mode": "game"             // 可选，"game" 或 "professional"
}
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "username": "string",
    "nickname": "string",
    "avatar_url": "string",
    "mode": "game"
  },
  "message": "用户信息已更新"
}
```

---

#### GET /api/v1/users/me/stats

**描述**: 获取当前用户统计数据

**认证**: 需要

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "total_tasks": 100,
    "completed_tasks": 75,
    "completion_rate": 0.75,
    "current_streak": 7,
    "longest_streak": 30,
    "total_xp": 500,
    "level": 5,
    "attributes": {
      "strength": 15,      // 力量（Q1）
      "wisdom": 20,        // 智慧（Q2）
      "agility": 10,       // 敏捷（Q3）
      "charisma": 8        // 魅力（Q4）
    },
    "achievements_count": 12
  }
}
```

---

## 5. 任务模块 API

### 5.1 任务管理

#### GET /api/v1/tasks

**描述**: 获取任务列表

**认证**: 需要

**查询参数**:
```
- quadrant: 象限过滤 (1, 2, 3, 4)
- status: 状态过滤 (todo, doing, done, archived)
- priority: 优先级过滤 (0-5)
- difficulty: 难度过滤 (1-5)
- due_date_from: 截止日期起始 (YYYY-MM-DD)
- due_date_to: 截止日期结束 (YYYY-MM-DD)
- tags: 标签过滤 (逗号分隔)
- page: 页码 (默认 1)
- page_size: 每页数量 (默认 20)
- sort: 排序字段 (created_at, due_date, priority)
- order: 排序方向 (asc, desc)
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "uuid",
        "title": "完成任务API设计",
        "description": "设计RESTful API接口",
        "quadrant": "urgent_important",
        "status": "doing",
        "priority": 3,
        "difficulty": 4,
        "xp_reward": 48,
        "due_date": "2026-03-10",
        "tags": ["工作", "重要"],
        "estimated_minutes": 120,
        "actual_minutes": null,
        "content_path": "data/tasks/user-uuid/task-uuid.md",
        "created_at": "2026-03-08T10:00:00Z",
        "updated_at": "2026-03-08T12:00:00Z",
        "completed_at": null
      }
    ],
    "pagination": {
      "page": 1,
      "page_size": 20,
      "total": 45,
      "total_pages": 3
    }
  }
}
```

---

#### GET /api/v1/tasks/{task_id}

**描述**: 获取单个任务详情

**认证**: 需要

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "title": "完成任务API设计",
    "description": "设计RESTful API接口",
    "quadrant": "urgent_important",
    "status": "doing",
    "priority": 3,
    "difficulty": 4,
    "xp_reward": 48,
    "due_date": "2026-03-10",
    "tags": ["工作", "重要"],
    "estimated_minutes": 120,
    "actual_minutes": null,
    "content_path": "data/tasks/user-uuid/task-uuid.md",
    "created_at": "2026-03-08T10:00:00Z",
    "updated_at": "2026-03-08T12:00:00Z",
    "completed_at": null
  }
}
```

---

#### POST /api/v1/tasks

**描述**: 创建任务

**认证**: 需要

**请求体**:
```json
{
  "title": "string",                    // 必填，最多255字符
  "description": "string",              // 可选
  "quadrant": "urgent_important",       // 必填，四象限类型
  "priority": 3,                        // 可选，默认0
  "difficulty": 3,                      // 可选，默认1，范围1-5
  "due_date": "2026-03-10",            // 可选
  "tags": ["工作", "重要"],            // 可选
  "estimated_minutes": 120,             // 可选
  "content": "# 任务标题\n\n内容..."    // 可选，Markdown内容
}
```

**象限枚举值**:
- `urgent_important`: 紧急且重要（第一象限）
- `not_urgent_important`: 重要不紧急（第二象限）
- `urgent_not_important`: 紧急不重要（第三象限）
- `not_urgent_not_important`: 不紧急不重要（第四象限）

**响应**: 201 Created
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "title": "完成任务API设计",
    "quadrant": "urgent_important",
    "status": "todo",
    "xp_reward": 36,  // 自动计算: difficulty * 10 * quadrant_bonus
    "created_at": "2026-03-08T10:00:00Z"
  },
  "message": "任务创建成功"
}
```

---

#### PUT /api/v1/tasks/{task_id}

**描述**: 更新任务

**认证**: 需要

**请求体**:
```json
{
  "title": "string",                    // 可选
  "description": "string",              // 可选
  "quadrant": "urgent_important",       // 可选
  "status": "doing",                    // 可选
  "priority": 3,                        // 可选
  "difficulty": 3,                      // 可选
  "due_date": "2026-03-10",            // 可选
  "tags": ["工作"],                    // 可选
  "estimated_minutes": 90               // 可选
}
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "title": "更新后的标题",
    "updated_at": "2026-03-08T14:00:00Z"
  },
  "message": "任务更新成功"
}
```

---

#### DELETE /api/v1/tasks/{task_id}

**描述**: 删除任务

**认证**: 需要

**响应**: 200 OK
```json
{
  "success": true,
  "message": "任务已删除"
}
```

---

#### POST /api/v1/tasks/{task_id}/complete

**描述**: 完成任务

**认证**: 需要

**请求体**:
```json
{
  "actual_minutes": 100,    // 可选，实际用时
  "reflection": "string"    // 可选，完成反思
}
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "task_id": "uuid",
    "xp_earned": 48,
    "new_xp": 548,
    "new_level": 5,
    "level_up": false,
    "streak_days": 8,
    "achievements": [  // 本次完成解锁的成就
      {
        "id": "uuid",
        "name": "任务达人",
        "description": "累计完成50个任务",
        "xp_bonus": 100
      }
    ]
  },
  "message": "任务已完成"
}
```

---

### 5.2 任务内容管理

#### GET /api/v1/tasks/{task_id}/content

**描述**: 获取任务 Markdown 内容

**认证**: 需要

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "content": "# 任务标题\n\n## 任务描述\n这是一个示例任务描述。\n\n## 行动计划\n1. 第一步\n2. 第二步\n\n## Checklist\n- [x] 已完成事项\n- [ ] 未完成事项"
  }
}
```

---

#### PUT /api/v1/tasks/{task_id}/content

**描述**: 更新任务 Markdown 内容

**认证**: 需要

**请求体**:
```json
{
  "content": "更新后的Markdown内容..."
}
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "updated_at": "2026-03-08T15:00:00Z"
  },
  "message": "任务内容已更新"
}
```

---

## 6. 游戏化系统 API

### 6.1 成就系统

#### GET /api/v1/achievements

**描述**: 获取用户成就列表

**认证**: 需要

**查询参数**:
```
- status: 成就状态 (unlocked, locked, all)
- page: 页码
- page_size: 每页数量
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "uuid",
        "achievement_type": "streak",
        "achievement_name": "一周坚持",
        "description": "连续7天完成任务",
        "xp_bonus": 50,
        "achieved_at": "2026-03-08T00:00:00Z",
        "is_hidden": false
      }
    ],
    "pagination": {
      "page": 1,
      "page_size": 20,
      "total": 15,
      "total_pages": 1
    },
    "summary": {
      "unlocked": 15,
      "total": 200,
      "hidden_remaining": 5
    }
  }
}
```

---

### 6.2 属性系统

#### GET /api/v1/users/me/attributes

**描述**: 获取用户属性值

**认证**: 需要

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "strength": 15,      // 力量（Q1）
    "wisdom": 20,        // 智慧（Q2）
    "agility": 10,       // 敏捷（Q3）
    "charisma": 8,       // 魅力（Q4）
    "balance_score": 75, // 平衡度分数 (0-100)
    "insight": "你的智慧属性突出，擅长长期规划。建议多关注第一象限任务，提升执行力。"
  }
}
```

---

## 7. 数据分析 API

### 7.1 每日简报

#### GET /api/v1/analytics/daily-briefing

**描述**: 获取今日数据简报

**认证**: 需要

**查询参数**:
```
- date: 日期 (YYYY-MM-DD)，默认今天
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "date": "2026-03-08",
    "yesterday_review": {
      "tasks_created": 8,
      "tasks_completed": 6,
      "average_duration": 45,
      "quadrant_distribution": [2, 3, 2, 1]
    },
    "key_insights": [
      "你上午完成了3个第二象限任务，效率最高",
      "本周第二象限任务占比提升15%"
    ],
    "today_suggestions": [
      "适合安排一个90分钟的深度工作块",
      "今天可以处理2-3个第一象限任务"
    ],
    "streak_status": {
      "current_streak": 7,
      "resurrections_used": 1,
      "resurrections_remaining": 2
    }
  }
}
```

---

### 7.2 周度报告

#### GET /api/v1/analytics/weekly-report

**描述**: 获取周度报告

**认证**: 需要

**查询参数**:
```
- week_start: 周起始日期 (YYYY-MM-DD)，默认本周一
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "week_start": "2026-03-02",
    "week_end": "2026-03-08",
    "metrics": {
      "completion_rate": 0.85,
      "on_time_rate": 0.92,
      "quadrant_health_score": 78,
      "average_difficulty": 3.2
    },
    "quadrant_distribution": {
      "q1": 0.22,
      "q2": 0.48,
      "q3": 0.20,
      "q4": 0.10
    },
    "best_moments": [
      "周三上午完成了5个重要任务",
      "连续7天完成了每日目标"
    ],
    "improvement_opportunities": [
      "可以尝试在早上9-11点处理重要任务",
      "第四象限任务较少，注意劳逸结合"
    ],
    "next_week_experiments": [
      {
        "name": "时间块实验",
        "description": "每天上午9-11点设为深度工作时间",
        "success_metric": "完成3个以上重要任务"
      }
    ]
  }
}
```

---

### 7.3 行为日志

#### GET /api/v1/analytics/behavior-logs

**描述**: 获取用户行为日志

**认证**: 需要

**查询参数**:
```
- action_type: 行为类型 (task_created, task_completed, etc.)
- date_from: 起始日期
- date_to: 结束日期
- page: 页码
- page_size: 每页数量
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "uuid",
        "action_type": "task_completed",
        "task_id": "uuid",
        "xp_earned": 48,
        "metadata": {
          "quadrant": 1,
          "difficulty": 3,
          "streak_bonus": 1.15
        },
        "created_at": "2026-03-08T14:30:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "page_size": 20,
      "total": 150,
      "total_pages": 8
    }
  }
}
```

---

## 8. AI 辅助 API

### 8.1 任务拆分

#### POST /api/v1/ai/decompose-task

**描述**: AI 辅助拆分长任务

**认证**: 需要

**请求体**:
```json
{
  "title": "准备托福考试",
  "description": "目标分数100分，备考时间90天",
  "duration_days": 90,
  "daily_minutes": 120,
  "current_level": "中级",
  "resources": [  // 可选，学习资源
    "Official TOEFL Guide",
    "TPO练习题"
  ]
}
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "subtasks": [
      {
        "title": "第1-2周：词汇基础",
        "description": "背诵核心词汇3000词",
        "duration_days": 14,
        "daily_minutes": 60,
        "difficulty": 2,
        "quadrant": "not_urgent_important"
      },
      {
        "title": "第3-4周：听力训练",
        "description": "每天2小时听力练习",
        "duration_days": 14,
        "daily_minutes": 120,
        "difficulty": 3,
        "quadrant": "not_urgent_important"
      }
      // ... 更多子任务
    ],
    "explanation": {
      "dependencies": "词汇是阅读和听力基础",
      "difficulty_curve": "从易到难，循序渐进",
      "estimated_total_hours": 180
    },
    "can_edit": true  // 用户可以编辑
  },
  "message": "任务拆分完成"
}
```

---

### 8.2 动态重规划

#### POST /api/v1/ai/replan

**描述**: AI 提供重规划建议

**认证**: 需要

**请求体**:
```json
{
  "long_task_id": "uuid",
  "reason": "work_busy",  // work_busy, task_too_hard, other
  "details": "最近工作很忙，无法按计划执行"
}
```

**响应**: 200 OK
```json
{
  "success": true,
  "data": {
    "options": [
      {
        "id": "option_1",
        "name": "延长本周目标",
        "description": "本周任务推迟3天完成",
        "impact": "最终截止日期延后3天",
        "recommended": true
      },
      {
        "id": "option_2",
        "name": "降低本周难度",
        "description": "本周任务难度降低1级",
        "impact": "后续需要增加5天时间"
      },
      {
        "id": "option_3",
        "name": "保持原计划",
        "description": "继续执行原计划",
        "impact": "需要在周末补足进度"
      }
    ],
    "user_can_choose": true
  },
  "message": "重规划建议已生成"
}
```

---

## 9. 错误码定义

### 9.1 HTTP 状态码

| 状态码 | 说明 | 使用场景 |
|--------|------|----------|
| 200 OK | 请求成功 | GET, PUT, DELETE 成功 |
| 201 Created | 资源创建成功 | POST 成功 |
| 204 No Content | 无内容返回 | DELETE 成功 |
| 400 Bad Request | 请求参数错误 | 参数验证失败 |
| 401 Unauthorized | 未认证 | 未登录或Token过期 |
| 403 Forbidden | 无权限 | 无权访问资源 |
| 404 Not Found | 资源不存在 | 资源未找到 |
| 409 Conflict | 资源冲突 | 用户名已存在等 |
| 422 Unprocessable Entity | 无法处理的实体 | 业务逻辑错误 |
| 500 Internal Server Error | 服务器内部错误 | 系统错误 |

### 9.2 业务错误码

| 错误码 | 说明 |
|--------|------|
| AUTH_001 | 用户名或密码错误 |
| AUTH_002 | Token已过期 |
| AUTH_003 | Token无效 |
| AUTH_004 | 邮箱已被注册 |
| AUTH_005 | 用户名已被使用 |
| TASK_001 | 任务不存在 |
| TASK_002 | 无权访问此任务 |
| TASK_003 | 任务状态无效 |
| TASK_004 | 四象限类型无效 |
| TASK_005 | 难度范围无效 (1-5) |
| AI_001 | AI服务暂时不可用 |
| AI_002 | AI调用次数已达上限 |
| AI_003 | 任务信息不足，无法拆分 |
| VALIDATION_001 | 请求参数验证失败 |
| VALIDATION_002 | 必填字段缺失 |
| VALIDATION_003 | 字段格式错误 |

### 9.3 错误响应示例

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_001",
    "message": "请求参数验证失败",
    "details": {
      "field": "difficulty",
      "reason": "难度必须在1-5之间"
    }
  }
}
```

---

## 附录

### A. XP 计算规则

**基础 XP**: `difficulty * 10`

**象限加成**:
- Q1 (紧急且重要): +20%
- Q2 (重要不紧急): +30%
- Q3 (紧急不重要): +10%
- Q4 (不紧急不重要): +5%

**连击奖励**:
- 3 天连击: +5%
- 7 天连击: +15%
- 30 天连击: +50%

**计算公式**:
```
total_xp = base_xp * (1 + quadrant_bonus) * (1 + streak_bonus)
```

**示例**:
```
难度3 + Q2 + 7天连击
= (3 * 10) * (1 + 0.30) * (1 + 0.15)
= 30 * 1.30 * 1.15
= 44.85 XP
```

---

### B. 环境变量配置

```bash
# 应用配置
APP_NAME=gamified_todo
APP_VERSION=1.0.0
APP_ENV=development  # development, staging, production

# 数据库配置
DB_HOST=localhost
DB_PORT=5432
DB_NAME=gamified_todo
DB_USER=postgres
DB_PASSWORD=your_password

# JWT配置
JWT_SECRET_KEY=your_secret_key
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_MINUTES=15
JWT_REFRESH_TOKEN_EXPIRE_DAYS=7

# AI配置
AI_API_KEY=your_claude_api_key
AI_MODEL=claude-sonnet-4-6
AI_MAX_TOKENS=4000

# 文件存储
STORAGE_PATH=./data
MAX_FILE_SIZE=5242880  # 5MB

# CORS配置
CORS_ORIGINS=["http://localhost:3000"]
```

---

**文档结束**

> 本 API 规范文档将根据项目进展持续更新。