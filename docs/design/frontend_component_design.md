# 前端组件设计文档

**文档版本**: v1.0
**创建日期**: 2026-03-08
**负责人**: David Kim (前端架构师)
**状态**: 初稿

---

## 文档修订记录

| 版本 | 日期 | 修改人 | 修改内容 |
|------|------|--------|----------|
| v1.0 | 2026-03-08 | David Kim | 初始版本 |

---

## 目录

1. [技术栈确认](#1-技术栈确认)
2. [项目结构](#2-项目结构)
3. [组件架构设计](#3-组件架构设计)
4. [状态管理设计](#4-状态管理设计)
5. [路由设计](#5-路由设计)
6. [核心组件设计](#6-核心组件设计)
7. [数据流设计](#7-数据流设计)
8. [性能优化策略](#8-性能优化策略)

---

## 1. 技术栈确认

### 1.1 核心技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue.js | 3.4+ | 前端框架 |
| TypeScript | 5.0+ | 类型系统 |
| Vite | 5.0+ | 构建工具 |
| Pinia | 2.1+ | 状态管理 |
| Vue Router | 4.2+ | 路由管理 |

### 1.2 UI 与样式

| 技术 | 版本 | 用途 |
|------|------|------|
| Tailwind CSS | 3.4+ | CSS 框架 |
| Headless UI | 1.7+ | 无样式组件库 |
| Heroicons | 2.1+ | 图标库 |
| Framer Motion | 11.0+ | 动画库 (Vue版: @vueuse/motion) |

### 1.3 数据处理

| 技术 | 版本 | 用途 |
|------|------|------|
| Axios | 1.6+ | HTTP 客户端 |
| VueUse | 10.7+ | Composition API 工具集 |
| date-fns | 3.0+ | 日期处理 |
| Zod | 3.22+ | 数据验证 |

### 1.4 开发工具

| 技术 | 版本 | 用途 |
|------|------|------|
| ESLint | 8.56+ | 代码检查 |
| Prettier | 3.1+ | 代码格式化 |
| Vitest | 1.1+ | 单元测试 |
| Playwright | 1.40+ | E2E 测试 |

---

## 2. 项目结构

```
gamified-todo/
├── public/
│   ├── favicon.ico
│   └── manifest.json          # PWA配置
├── src/
│   ├── api/                   # API接口
│   │   ├── client.ts          # Axios配置
│   │   ├── auth.api.ts        # 认证API
│   │   ├── tasks.api.ts       # 任务API
│   │   ├── gamification.api.ts # 游戏化API
│   │   └── analytics.api.ts   # 数据分析API
│   ├── assets/                # 静态资源
│   │   ├── images/
│   │   └── styles/
│   │       ├── main.css       # 全局样式
│   │       └── animations.css # 动画样式
│   ├── components/            # 组件
│   │   ├── common/            # 通用组件
│   │   │   ├── BaseButton.vue
│   │   │   ├── BaseInput.vue
│   │   │   ├── BaseModal.vue
│   │   │   └── BaseCard.vue
│   │   ├── layout/            # 布局组件
│   │   │   ├── AppHeader.vue
│   │   │   ├── AppSidebar.vue
│   │   │   └── AppFooter.vue
│   │   ├── task/              # 任务组件
│   │   │   ├── TaskCard.vue
│   │   │   ├── TaskForm.vue
│   │   │   ├── TaskList.vue
│   │   │   └── QuadrantView.vue
│   │   ├── gamification/      # 游戏化组件
│   │   │   ├── XPDisplay.vue
│   │   │   ├── LevelBadge.vue
│   │   │   ├── StreakCounter.vue
│   │   │   └── AchievementToast.vue
│   │   └── analytics/         # 分析组件
│   │       ├── DailyBriefing.vue
│   │       ├── WeeklyReport.vue
│   │       └── QuadrantChart.vue
│   ├── composables/           # 组合式函数
│   │   ├── useAuth.ts
│   │   ├── useTasks.ts
│   │   ├── useGamification.ts
│   │   └── useNotifications.ts
│   ├── constants/             # 常量
│   │   ├── quadrant.ts        # 四象限常量
│   │   ├── status.ts          # 任务状态
│   │   └── achievements.ts    # 成就定义
│   ├── router/                # 路由
│   │   └── index.ts
│   ├── stores/                # Pinia状态管理
│   │   ├── auth.store.ts
│   │   ├── tasks.store.ts
│   │   ├── user.store.ts
│   │   └── ui.store.ts
│   ├── types/                 # TypeScript类型
│   │   ├── api.types.ts
│   │   ├── task.types.ts
│   │   ├── user.types.ts
│   │   └── gamification.types.ts
│   ├── utils/                 # 工具函数
│   │   ├── xp-calculator.ts   # XP计算
│   │   ├── date-helpers.ts    # 日期处理
│   │   ├── validators.ts      # 数据验证
│   │   └── markdown-parser.ts # Markdown解析
│   ├── views/                 # 页面视图
│   │   ├── HomeView.vue
│   │   ├── LoginView.vue
│   │   ├── RegisterView.vue
│   │   ├── TasksView.vue
│   │   ├── TaskDetailView.vue
│   │   ├── AnalyticsView.vue
│   │   └── SettingsView.vue
│   ├── App.vue                # 根组件
│   └── main.ts                # 入口文件
├── tests/                     # 测试
│   ├── unit/
│   └── e2e/
├── .env                       # 环境变量
├── .env.development
├── .env.production
├── index.html
├── package.json
├── tsconfig.json
├── vite.config.ts
└── tailwind.config.js
```

---

## 3. 组件架构设计

### 3.1 组件分层架构

```
┌─────────────────────────────────────────────────┐
│                  Views (页面层)                   │
│  HomeView, TasksView, TaskDetailView, etc.      │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│              Feature Components (功能组件层)      │
│  TaskList, QuadrantView, XPDisplay, etc.        │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│              Common Components (通用组件层)       │
│  BaseButton, BaseInput, BaseModal, etc.         │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│              Layout Components (布局组件层)       │
│  AppHeader, AppSidebar, AppFooter               │
└─────────────────────────────────────────────────┘
```

### 3.2 组件通信方式

| 通信方式 | 使用场景 | 示例 |
|---------|---------|------|
| Props / Emits | 父子组件通信 | TaskCard 接收 task prop |
| Provide / Inject | 深层嵌套组件 | 主题配置 |
| Pinia Store | 跨组件状态共享 | 用户信息、任务列表 |
| Event Bus | 非父子组件通信 | 全局通知 |

---

## 4. 状态管理设计

### 4.1 Store 结构

#### auth.store.ts - 认证状态

```typescript
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { User, LoginCredentials, RegisterData } from '@/types/user.types'
import * as authApi from '@/api/auth.api'

export const useAuthStore = defineStore('auth', () => {
  // State
  const user = ref<User | null>(null)
  const token = ref<string | null>(localStorage.getItem('access_token'))
  const refreshToken = ref<string | null>(localStorage.getItem('refresh_token'))

  // Getters
  const isAuthenticated = computed(() => !!token.value)
  const userLevel = computed(() => user.value?.level || 1)
  const userXP = computed(() => user.value?.xp || 0)

  // Actions
  async function login(credentials: LoginCredentials) {
    const response = await authApi.login(credentials)
    user.value = response.data.user
    token.value = response.data.token.access_token
    refreshToken.value = response.data.token.refresh_token

    // 持久化到 localStorage
    localStorage.setItem('access_token', token.value!)
    localStorage.setItem('refresh_token', refreshToken.value!)
  }

  async function register(data: RegisterData) {
    const response = await authApi.register(data)
    user.value = response.data.user
    token.value = response.data.token.access_token
    refreshToken.value = response.data.token.refresh_token

    localStorage.setItem('access_token', token.value!)
    localStorage.setItem('refresh_token', refreshToken.value!)
  }

  function logout() {
    user.value = null
    token.value = null
    refreshToken.value = null
    localStorage.removeItem('access_token')
    localStorage.removeItem('refresh_token')
  }

  async function refreshAccessToken() {
    if (!refreshToken.value) return

    const response = await authApi.refreshToken(refreshToken.value)
    token.value = response.data.access_token
    localStorage.setItem('access_token', token.value!)
  }

  return {
    // State
    user,
    token,
    refreshToken,
    // Getters
    isAuthenticated,
    userLevel,
    userXP,
    // Actions
    login,
    register,
    logout,
    refreshAccessToken
  }
})
```

---

#### tasks.store.ts - 任务状态

```typescript
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Task, CreateTaskData, UpdateTaskData, Quadrant } from '@/types/task.types'
import * as tasksApi from '@/api/tasks.api'

export const useTasksStore = defineStore('tasks', () => {
  // State
  const tasks = ref<Task[]>([])
  const currentTask = ref<Task | null>(null)
  const loading = ref(false)
  const filters = ref({
    quadrant: null as Quadrant | null,
    status: null as string | null,
    search: ''
  })

  // Getters
  const tasksByQuadrant = computed(() => ({
    q1: tasks.value.filter(t => t.quadrant === 'urgent_important'),
    q2: tasks.value.filter(t => t.quadrant === 'not_urgent_important'),
    q3: tasks.value.filter(t => t.quadrant === 'urgent_not_important'),
    q4: tasks.value.filter(t => t.quadrant === 'not_urgent_not_important')
  }))

  const filteredTasks = computed(() => {
    let result = tasks.value

    if (filters.value.quadrant) {
      result = result.filter(t => t.quadrant === filters.value.quadrant)
    }

    if (filters.value.status) {
      result = result.filter(t => t.status === filters.value.status)
    }

    if (filters.value.search) {
      result = result.filter(t =>
        t.title.toLowerCase().includes(filters.value.search.toLowerCase())
      )
    }

    return result
  })

  const todoTasks = computed(() =>
    tasks.value.filter(t => t.status === 'todo')
  )

  const completedTasks = computed(() =>
    tasks.value.filter(t => t.status === 'done')
  )

  // Actions
  async function fetchTasks(params = {}) {
    loading.value = true
    try {
      const response = await tasksApi.getTasks(params)
      tasks.value = response.data.items
    } finally {
      loading.value = false
    }
  }

  async function createTask(data: CreateTaskData) {
    const response = await tasksApi.createTask(data)
    tasks.value.unshift(response.data)
    return response.data
  }

  async function updateTask(taskId: string, data: UpdateTaskData) {
    const response = await tasksApi.updateTask(taskId, data)
    const index = tasks.value.findIndex(t => t.id === taskId)
    if (index !== -1) {
      tasks.value[index] = response.data
    }
    return response.data
  }

  async function deleteTask(taskId: string) {
    await tasksApi.deleteTask(taskId)
    tasks.value = tasks.value.filter(t => t.id !== taskId)
  }

  async function completeTask(taskId: string, actualMinutes?: number) {
    const response = await tasksApi.completeTask(taskId, { actual_minutes: actualMinutes })

    // 更新任务状态
    const index = tasks.value.findIndex(t => t.id === taskId)
    if (index !== -1) {
      tasks.value[index] = response.data.task
    }

    // 返回XP和成就信息
    return {
      xpEarned: response.data.xp_earned,
      newLevel: response.data.new_level,
      levelUp: response.data.level_up,
      achievements: response.data.achievements
    }
  }

  function setFilters(newFilters: Partial<typeof filters.value>) {
    filters.value = { ...filters.value, ...newFilters }
  }

  function clearFilters() {
    filters.value = {
      quadrant: null,
      status: null,
      search: ''
    }
  }

  return {
    // State
    tasks,
    currentTask,
    loading,
    filters,
    // Getters
    tasksByQuadrant,
    filteredTasks,
    todoTasks,
    completedTasks,
    // Actions
    fetchTasks,
    createTask,
    updateTask,
    deleteTask,
    completeTask,
    setFilters,
    clearFilters
  }
})
```

---

#### user.store.ts - 用户状态

```typescript
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { UserStats, Attributes } from '@/types/user.types'
import * as userApi from '@/api/user.api'

export const useUserStore = defineStore('user', () => {
  // State
  const stats = ref<UserStats | null>(null)
  const attributes = ref<Attributes | null>(null)

  // Getters
  const totalXP = computed(() => stats.value?.total_xp || 0)
  const currentLevel = computed(() => stats.value?.level || 1)
  const currentStreak = computed(() => stats.value?.current_streak || 0)

  // Actions
  async function fetchUserStats() {
    const response = await userApi.getUserStats()
    stats.value = response.data
  }

  async function fetchUserAttributes() {
    const response = await userApi.getUserAttributes()
    attributes.value = response.data
  }

  async function updateUserXP(xpEarned: number) {
    if (stats.value) {
      stats.value.total_xp += xpEarned
    }
  }

  return {
    // State
    stats,
    attributes,
    // Getters
    totalXP,
    currentLevel,
    currentStreak,
    // Actions
    fetchUserStats,
    fetchUserAttributes,
    updateUserXP
  }
})
```

---

## 5. 路由设计

### 5.1 路由配置

```typescript
// src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth.store'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/HomeView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue'),
    meta: { guest: true }
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('@/views/RegisterView.vue'),
    meta: { guest: true }
  },
  {
    path: '/tasks',
    name: 'tasks',
    component: () => import('@/views/TasksView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/tasks/:id',
    name: 'task-detail',
    component: () => import('@/views/TaskDetailView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/analytics',
    name: 'analytics',
    component: () => import('@/views/AnalyticsView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/settings',
    name: 'settings',
    component: () => import('@/views/SettingsView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('@/views/NotFoundView.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next({ name: 'login', query: { redirect: to.fullPath } })
  } else if (to.meta.guest && authStore.isAuthenticated) {
    next({ name: 'home' })
  } else {
    next()
  }
})

export default router
```

---

## 6. 核心组件设计

### 6.1 四象限视图组件 (QuadrantView.vue)

```vue
<template>
  <div class="quadrant-view grid grid-cols-2 gap-4 p-6">
    <!-- 第一象限: 紧急且重要 -->
    <div class="quadrant bg-red-50 border-2 border-red-300 rounded-lg p-4">
      <div class="flex items-center justify-between mb-3">
        <h3 class="text-lg font-bold text-red-700">🔥 紧急且重要</h3>
        <span class="text-sm text-red-600">{{ q1Tasks.length }} 个任务</span>
      </div>
      <div class="task-list space-y-2">
        <TaskCard
          v-for="task in q1Tasks"
          :key="task.id"
          :task="task"
          @complete="handleCompleteTask"
          @edit="handleEditTask"
        />
      </div>
      <button
        @click="openCreateTask('urgent_important')"
        class="mt-3 w-full py-2 text-sm text-red-600 hover:bg-red-100 rounded"
      >
        + 添加任务
      </button>
    </div>

    <!-- 第二象限: 重要不紧急 -->
    <div class="quadrant bg-blue-50 border-2 border-blue-300 rounded-lg p-4">
      <div class="flex items-center justify-between mb-3">
        <h3 class="text-lg font-bold text-blue-700">🌱 重要不紧急</h3>
        <span class="text-sm text-blue-600">{{ q2Tasks.length }} 个任务</span>
      </div>
      <div class="task-list space-y-2">
        <TaskCard
          v-for="task in q2Tasks"
          :key="task.id"
          :task="task"
          @complete="handleCompleteTask"
          @edit="handleEditTask"
        />
      </div>
      <button
        @click="openCreateTask('not_urgent_important')"
        class="mt-3 w-full py-2 text-sm text-blue-600 hover:bg-blue-100 rounded"
      >
        + 添加任务
      </button>
    </div>

    <!-- 第三象限: 紧急不重要 -->
    <div class="quadrant bg-yellow-50 border-2 border-yellow-300 rounded-lg p-4">
      <div class="flex items-center justify-between mb-3">
        <h3 class="text-lg font-bold text-yellow-700">⚡ 紧急不重要</h3>
        <span class="text-sm text-yellow-600">{{ q3Tasks.length }} 个任务</span>
      </div>
      <div class="task-list space-y-2">
        <TaskCard
          v-for="task in q3Tasks"
          :key="task.id"
          :task="task"
          @complete="handleCompleteTask"
          @edit="handleEditTask"
        />
      </div>
      <button
        @click="openCreateTask('urgent_not_important')"
        class="mt-3 w-full py-2 text-sm text-yellow-600 hover:bg-yellow-100 rounded"
      >
        + 添加任务
      </button>
    </div>

    <!-- 第四象限: 不紧急不重要 -->
    <div class="quadrant bg-green-50 border-2 border-green-300 rounded-lg p-4">
      <div class="flex items-center justify-between mb-3">
        <h3 class="text-lg font-bold text-green-700">🎮 休闲时光</h3>
        <span class="text-sm text-green-600">{{ q4Tasks.length }} 个任务</span>
      </div>
      <div class="task-list space-y-2">
        <TaskCard
          v-for="task in q4Tasks"
          :key="task.id"
          :task="task"
          @complete="handleCompleteTask"
          @edit="handleEditTask"
        />
      </div>
      <button
        @click="openCreateTask('not_urgent_not_important')"
        class="mt-3 w-full py-2 text-sm text-green-600 hover:bg-green-100 rounded"
      >
        + 添加任务
      </button>
    </div>

    <!-- 创建任务弹窗 -->
    <TaskForm
      v-if="showTaskForm"
      :quadrant="selectedQuadrant"
      @close="showTaskForm = false"
      @created="handleTaskCreated"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useTasksStore } from '@/stores/tasks.store'
import TaskCard from './TaskCard.vue'
import TaskForm from './TaskForm.vue'
import type { Quadrant, Task } from '@/types/task.types'

const tasksStore = useTasksStore()

const showTaskForm = ref(false)
const selectedQuadrant = ref<Quadrant | null>(null)

const q1Tasks = computed(() => tasksStore.tasksByQuadrant.q1)
const q2Tasks = computed(() => tasksStore.tasksByQuadrant.q2)
const q3Tasks = computed(() => tasksStore.tasksByQuadrant.q3)
const q4Tasks = computed(() => tasksStore.tasksByQuadrant.q4)

function openCreateTask(quadrant: Quadrant) {
  selectedQuadrant.value = quadrant
  showTaskForm.value = true
}

async function handleCompleteTask(taskId: string) {
  try {
    const result = await tasksStore.completeTask(taskId)
    // 显示XP获得动画
    showXPEarnedAnimation(result.xpEarned)

    // 如果有新成就，显示成就提示
    if (result.achievements.length > 0) {
      showAchievementToast(result.achievements)
    }
  } catch (error) {
    console.error('完成任务失败:', error)
  }
}

function handleEditTask(task: Task) {
  // 跳转到任务编辑页面
  // router.push({ name: 'task-detail', params: { id: task.id } })
}

function handleTaskCreated() {
  showTaskForm.value = false
  selectedQuadrant.value = null
}

function showXPEarnedAnimation(xp: number) {
  // 显示XP飞入动画
}

function showAchievementToast(achievements: any[]) {
  // 显示成就解锁提示
}
</script>
```

---

### 6.2 任务卡片组件 (TaskCard.vue)

```vue
<template>
  <div
    class="task-card bg-white rounded-lg shadow-sm border p-3 cursor-pointer hover:shadow-md transition-shadow"
    :class="{
      'border-red-300': task.quadrant === 'urgent_important',
      'border-blue-300': task.quadrant === 'not_urgent_important',
      'border-yellow-300': task.quadrant === 'urgent_not_important',
      'border-green-300': task.quadrant === 'not_urgent_not_important'
    }"
    @click="$emit('edit', task)"
  >
    <!-- 任务标题 -->
    <div class="flex items-start justify-between mb-2">
      <h4 class="font-medium text-gray-900 flex-1">{{ task.title }}</h4>
      <span
        class="text-xs font-medium px-2 py-1 rounded"
        :class="statusClasses"
      >
        {{ statusText }}
      </span>
    </div>

    <!-- 任务描述 -->
    <p v-if="task.description" class="text-sm text-gray-600 mb-2">
      {{ task.description }}
    </p>

    <!-- 任务元数据 -->
    <div class="flex items-center gap-3 text-xs text-gray-500 mb-2">
      <span v-if="task.due_date" class="flex items-center gap-1">
        <CalendarIcon class="w-3 h-3" />
        {{ formatDate(task.due_date) }}
      </span>
      <span class="flex items-center gap-1">
        <StarIcon class="w-3 h-3" />
        难度 {{ task.difficulty }}
      </span>
      <span class="flex items-center gap-1 text-amber-600 font-medium">
        <SparklesIcon class="w-3 h-3" />
        +{{ task.xp_reward }} XP
      </span>
    </div>

    <!-- 标签 -->
    <div v-if="task.tags && task.tags.length > 0" class="flex flex-wrap gap-1 mb-2">
      <span
        v-for="tag in task.tags"
        :key="tag"
        class="text-xs bg-gray-100 text-gray-600 px-2 py-0.5 rounded"
      >
        {{ tag }}
      </span>
    </div>

    <!-- 操作按钮 -->
    <div class="flex items-center justify-end gap-2 mt-2 pt-2 border-t">
      <button
        v-if="task.status !== 'done'"
        @click.stop="handleComplete"
        class="text-xs text-green-600 hover:text-green-700 font-medium"
      >
        ✓ 完成
      </button>
      <button
        @click.stop="handleEdit"
        class="text-xs text-blue-600 hover:text-blue-700"
      >
        编辑
      </button>
      <button
        @click.stop="handleDelete"
        class="text-xs text-red-600 hover:text-red-700"
      >
        删除
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { CalendarIcon, StarIcon, SparklesIcon } from '@heroicons/vue/24/outline'
import type { Task } from '@/types/task.types'
import { format } from 'date-fns'

interface Props {
  task: Task
}

const props = defineProps<Props>()

const emit = defineEmits<{
  complete: [taskId: string]
  edit: [task: Task]
  delete: [taskId: string]
}>()

const statusClasses = computed(() => {
  const classes = {
    todo: 'bg-gray-100 text-gray-600',
    doing: 'bg-blue-100 text-blue-600',
    done: 'bg-green-100 text-green-600',
    archived: 'bg-gray-100 text-gray-400'
  }
  return classes[props.task.status] || classes.todo
})

const statusText = computed(() => {
  const texts = {
    todo: '待办',
    doing: '进行中',
    done: '已完成',
    archived: '已归档'
  }
  return texts[props.task.status] || '待办'
})

function formatDate(date: string) {
  return format(new Date(date), 'MM-dd')
}

function handleComplete() {
  emit('complete', props.task.id)
}

function handleEdit() {
  emit('edit', props.task)
}

function handleDelete() {
  if (confirm('确定要删除这个任务吗？')) {
    emit('delete', props.task.id)
  }
}
</script>
```

---

### 6.3 XP 显示组件 (XPDisplay.vue)

```vue
<template>
  <div class="xp-display flex items-center gap-2">
    <!-- XP 数值 -->
    <div class="flex items-center gap-1">
      <SparklesIcon class="w-5 h-5 text-amber-500" />
      <span class="font-bold text-amber-600">{{ currentXP }}</span>
      <span class="text-xs text-gray-500">XP</span>
    </div>

    <!-- 等级徽章 -->
    <div class="level-badge bg-gradient-to-r from-purple-500 to-pink-500 text-white px-2 py-1 rounded-full text-xs font-bold">
      Lv.{{ currentLevel }}
    </div>

    <!-- 升级进度条 -->
    <div class="progress-bar w-24 h-2 bg-gray-200 rounded-full overflow-hidden">
      <div
        class="h-full bg-gradient-to-r from-amber-400 to-amber-600 transition-all duration-500"
        :style="{ width: `${progressPercent}%` }"
      ></div>
    </div>

    <!-- 距离下一级 -->
    <span class="text-xs text-gray-500">
      {{ xpToNextLevel }} XP 升级
    </span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { SparklesIcon } from '@heroicons/vue/24/outline'
import { useUserStore } from '@/stores/user.store'
import { getXPForLevel } from '@/utils/xp-calculator'

const userStore = useUserStore()

const currentXP = computed(() => userStore.totalXP)
const currentLevel = computed(() => userStore.currentLevel)

const currentLevelXP = computed(() => getXPForLevel(currentLevel.value))
const nextLevelXP = computed(() => getXPForLevel(currentLevel.value + 1))
const xpToNextLevel = computed(() => nextLevelXP.value - currentXP.value)

const progressPercent = computed(() => {
  const progress = currentXP.value - currentLevelXP.value
  const required = nextLevelXP.value - currentLevelXP.value
  return (progress / required) * 100
})
</script>
```

---

## 7. 数据流设计

### 7.1 数据流向图

```
┌─────────────┐
│  API Server │
└──────┬──────┘
       ↓
┌─────────────┐
│  API Layer  │  ← Axios HTTP Client
│  (api/*.ts) │
└──────┬──────┘
       ↓
┌─────────────┐
│ Pinia Store │  ← 状态管理
└──────┬──────┘
       ↓
┌─────────────┐
│ Composables │  ← 业务逻辑复用
└──────┬──────┘
       ↓
┌─────────────┐
│  Components │  ← Vue 组件
└─────────────┘
```

### 7.2 数据流转示例

```typescript
// 用户创建任务流程
1. 用户填写任务表单 → TaskForm.vue
2. 触发 createTask 方法 → tasks.store.ts
3. 调用 API → tasks.api.ts
4. 发送 HTTP 请求 → POST /api/v1/tasks
5. 接收响应 → tasks.api.ts
6. 更新 Store 状态 → tasks.store.ts
7. 组件自动响应更新 → QuadrantView.vue
8. 显示新任务 → TaskCard.vue

// 任务完成流程
1. 用户点击"完成"按钮 → TaskCard.vue
2. 触发 completeTask 方法 → tasks.store.ts
3. 调用 API → tasks.api.ts
4. 发送 HTTP 请求 → POST /api/v1/tasks/{id}/complete
5. 接收响应（XP、成就） → tasks.api.ts
6. 更新任务状态 → tasks.store.ts
7. 更新用户 XP → user.store.ts
8. 显示 XP 动画 → XPDisplay.vue
9. 显示成就提示 → AchievementToast.vue
```

---

## 8. 性能优化策略

### 8.1 代码分割

```typescript
// 路由懒加载
const TasksView = () => import('@/views/TasksView.vue')
const AnalyticsView = () => import('@/views/AnalyticsView.vue')

// 组件懒加载
const TaskForm = defineAsyncComponent(() =>
  import('@/components/task/TaskForm.vue')
)
```

### 8.2 虚拟滚动

```vue
<template>
  <RecycleScroller
    :items="tasks"
    :item-size="80"
    key-field="id"
  >
    <template #default="{ item }">
      <TaskCard :task="item" />
    </template>
  </RecycleScroller>
</template>
```

### 8.3 缓存策略

```typescript
// API 响应缓存
const cache = new Map()

async function fetchTasks(params: any) {
  const cacheKey = JSON.stringify(params)

  if (cache.has(cacheKey)) {
    return cache.get(cacheKey)
  }

  const response = await tasksApi.getTasks(params)
  cache.set(cacheKey, response)

  // 5分钟后清除缓存
  setTimeout(() => cache.delete(cacheKey), 5 * 60 * 1000)

  return response
}
```

### 8.4 防抖与节流

```typescript
// 搜索防抖
import { useDebounceFn } from '@vueuse/core'

const searchQuery = ref('')
const debouncedSearch = useDebounceFn(() => {
  tasksStore.setFilters({ search: searchQuery.value })
}, 300)

watch(searchQuery, debouncedSearch)
```

---

## 9. 测试策略

### 9.1 单元测试

```typescript
// tests/unit/xp-calculator.test.ts
import { describe, it, expect } from 'vitest'
import { calculateXP } from '@/utils/xp-calculator'

describe('XP Calculator', () => {
  it('应该正确计算基础 XP', () => {
    const result = calculateXP({ difficulty: 3 })
    expect(result.baseXP).toBe(30)
  })

  it('应该正确应用象限加成', () => {
    const result = calculateXP({
      difficulty: 3,
      quadrant: 'not_urgent_important'
    })
    expect(result.totalXP).toBe(39) // 30 * 1.3
  })

  it('应该正确应用连击奖励', () => {
    const result = calculateXP({
      difficulty: 3,
      quadrant: 'not_urgent_important',
      streakDays: 7
    })
    expect(result.totalXP).toBeCloseTo(44.85, 2) // 30 * 1.3 * 1.15
  })
})
```

### 9.2 组件测试

```typescript
// tests/unit/TaskCard.test.ts
import { mount } from '@vue/test-utils'
import TaskCard from '@/components/task/TaskCard.vue'
import { createTestingPinia } from '@pinia/testing'

describe('TaskCard', () => {
  it('应该正确渲染任务标题', () => {
    const wrapper = mount(TaskCard, {
      props: {
        task: {
          id: '1',
          title: '测试任务',
          quadrant: 'urgent_important',
          status: 'todo',
          difficulty: 3,
          xp_reward: 36
        }
      },
      global: {
        plugins: [createTestingPinia()]
      }
    })

    expect(wrapper.text()).toContain('测试任务')
  })

  it('点击完成按钮应该触发 complete 事件', async () => {
    const wrapper = mount(TaskCard, {
      props: { task: mockTask }
    })

    await wrapper.find('button:contains("完成")').trigger('click')
    expect(wrapper.emitted('complete')).toBeTruthy()
  })
})
```

---

**文档结束**

> 本前端组件设计文档将根据项目进展持续更新。