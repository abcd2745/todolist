# UI/UX 设计文档

**文档版本**: v1.0
**创建日期**: 2026-03-08
**负责人**: Maya (UI/UX 设计师)
**状态**: 初稿

---

## 文档修订记录

| 版本 | 日期 | 修改人 | 修改内容 |
|------|------|--------|----------|
| v1.0 | 2026-03-08 | Maya | 初始版本 |

---

## 目录

1. [设计理念](#1-设计理念)
2. [设计系统](#2-设计系统)
3. [核心页面设计](#3-核心页面设计)
4. [组件设计规范](#4-组件设计规范)
5. [交互动画设计](#5-交互动画设计)
6. [响应式设计](#6-响应式设计)
7. [文案设计规范](#7-文案设计规范)

---

## 1. 设计理念

### 1.1 核心设计原则

**产品定位**: "理解我、帮助我、不评判我"的成长伙伴

**设计原则**:
1. ✅ **温暖友好** - 使用柔和的颜色、圆润的形状、温暖的文案
2. ✅ **简洁直观** - 降低认知负担，快速上手
3. ✅ **正向激励** - 强调成就和进步，而非不足和批评
4. ✅ **游戏化体验** - 融入游戏元素，增加趣味性和成就感
5. ✅ **数据可视化** - 用图表和动画展示成长轨迹

### 1.2 设计风格

**视觉风格**: 现代简约 + 游戏化元素

**关键词**:
- 清新明快
- 友好温暖
- 游戏化趣味
- 数据可视化

---

## 2. 设计系统

### 2.1 颜色系统

#### 主色调

```css
/* 品牌色 */
--primary-500: #6366F1;  /* 主色（靛蓝） */
--primary-600: #4F46E5;
--primary-700: #4338CA;

/* 成功色 */
--success-500: #10B981;  /* 绿色 - 任务完成 */
--success-600: #059669;

/* 警告色 */
--warning-500: #F59E0B;  /* 橙色 - 提醒 */
--warning-600: #D97706;

/* 错误色 */
--error-500: #EF4444;    /* 红色 - 紧急 */
--error-600: #DC2626;
```

#### 四象限配色

```css
/* 第一象限: 紧急且重要 */
--quadrant-1-light: #FEE2E2;  /* 浅红背景 */
--quadrant-1-main: #EF4444;   /* 红色 */
--quadrant-1-dark: #B91C1C;

/* 第二象限: 重要不紧急 */
--quadrant-2-light: #DBEAFE;  /* 浅蓝背景 */
--quadrant-2-main: #3B82F6;   /* 蓝色 */
--quadrant-2-dark: #1E40AF;

/* 第三象限: 紧急不重要 */
--quadrant-3-light: #FEF3C7;  /* 浅黄背景 */
--quadrant-3-main: #F59E0B;   /* 黄色 */
--quadrant-3-dark: #B45309;

/* 第四象限: 不紧急不重要 */
--quadrant-4-light: #D1FAE5;  /* 浅绿背景 */
--quadrant-4-main: #10B981;   /* 绿色 */
--quadrant-4-dark: #047857;
```

#### 游戏化配色

```css
/* XP 经验值 */
--xp-gold: #FBBF24;        /* 金色 */
--xp-gold-light: #FDE68A;
--xp-gold-dark: #D97706;

/* 等级徽章 */
--level-purple: #8B5CF6;   /* 紫色 */
--level-purple-light: #A78BFA;
--level-purple-dark: #6D28D9;

/* 连击火焰 */
--streak-orange: #F97316;  /* 橙色 */
--streak-orange-light: #FDBA74;
--streak-orange-dark: #C2410C;

/* 成就星星 */
--achievement-yellow: #FCD34D; /* 黄色 */
```

---

### 2.2 字体系统

#### 字体家族

```css
/* 主字体 */
--font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;

/* 标题字体 */
--font-heading: 'Poppins', 'Inter', sans-serif;

/* 等宽字体（代码） */
--font-mono: 'JetBrains Mono', 'Fira Code', monospace;
```

#### 字体大小

```css
/* 标题 */
--text-4xl: 2.25rem;  /* 36px - 页面主标题 */
--text-3xl: 1.875rem; /* 30px - 区块标题 */
--text-2xl: 1.5rem;   /* 24px - 卡片标题 */
--text-xl: 1.25rem;   /* 20px - 小标题 */

/* 正文 */
--text-lg: 1.125rem;  /* 18px - 大正文 */
--text-base: 1rem;    /* 16px - 正文 */
--text-sm: 0.875rem;  /* 14px - 小字 */
--text-xs: 0.75rem;   /* 12px - 辅助文字 */
```

#### 字重

```css
--font-normal: 400;
--font-medium: 500;
--font-semibold: 600;
--font-bold: 700;
```

---

### 2.3 间距系统

```css
/* 基于 4px 的间距系统 */
--spacing-0: 0;
--spacing-1: 0.25rem;  /* 4px */
--spacing-2: 0.5rem;   /* 8px */
--spacing-3: 0.75rem;  /* 12px */
--spacing-4: 1rem;     /* 16px */
--spacing-5: 1.25rem;  /* 20px */
--spacing-6: 1.5rem;   /* 24px */
--spacing-8: 2rem;     /* 32px */
--spacing-10: 2.5rem;  /* 40px */
--spacing-12: 3rem;    /* 48px */
--spacing-16: 4rem;    /* 64px */
```

---

### 2.4 圆角系统

```css
--rounded-sm: 0.25rem;   /* 4px */
--rounded: 0.5rem;       /* 8px */
--rounded-md: 0.75rem;   /* 12px */
--rounded-lg: 1rem;      /* 16px */
--rounded-xl: 1.5rem;    /* 24px */
--rounded-2xl: 2rem;     /* 32px */
--rounded-full: 9999px;  /* 圆形 */
```

---

### 2.5 阴影系统

```css
/* 卡片阴影 */
--shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
--shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
--shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
--shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
--shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
```

---

## 3. 核心页面设计

### 3.1 四象限任务视图

#### 页面布局

```
┌────────────────────────────────────────────────────────┐
│  Header: Logo | XP Display | Level Badge | User Menu   │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ┌──────────────────────┐  ┌──────────────────────┐  │
│  │  🔥 紧急且重要 (Q1)   │  │  🌱 重要不紧急 (Q2)  │  │
│  │                      │  │                      │  │
│  │  [Task Card]         │  │  [Task Card]         │  │
│  │  [Task Card]         │  │  [Task Card]         │  │
│  │  [Task Card]         │  │  [Task Card]         │  │
│  │                      │  │                      │  │
│  │  [+ 添加任务]        │  │  [+ 添加任务]        │  │
│  └──────────────────────┘  └──────────────────────┘  │
│                                                        │
│  ┌──────────────────────┐  ┌──────────────────────┐  │
│  │  ⚡ 紧急不重要 (Q3)  │  │  🎮 休闲时光 (Q4)    │  │
│  │                      │  │                      │  │
│  │  [Task Card]         │  │  [Task Card]         │  │
│  │  [Task Card]         │  │                      │  │
│  │                      │  │  [+ 添加任务]        │  │
│  │  [+ 添加任务]        │  │                      │  │
│  └──────────────────────┘  └──────────────────────┘  │
│                                                        │
│  Sidebar: Streak Counter | Quick Stats                │
└────────────────────────────────────────────────────────┘
```

#### 设计要点

1. **四象限网格布局**
   - 使用 2x2 网格布局
   - 每个象限使用对应主题色
   - 象限标题使用图标 + 文字

2. **任务卡片设计**
   - 白色卡片，带对应象限边框色
   - 显示任务标题、截止日期、难度、XP奖励
   - 快速操作按钮（完成、编辑、删除）

3. **游戏化元素**
   - 顶部显示 XP、等级、连击天数
   - 完成任务时显示 XP 飞入动画
   - 升级时显示全屏庆祝动画

---

### 3.2 任务详情页

#### 页面布局

```
┌────────────────────────────────────────────────────────┐
│  ← 返回  |  编辑任务  |  删除任务                        │
├────────────────────────────────────────────────────────┤
│                                                        │
│  任务标题: 完成项目API设计                              │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                                        │
│  象限: 🔥 紧急且重要    状态: 进行中                    │
│  难度: ⭐⭐⭐⭐ (4/5)   奖励: +48 XP                   │
│  截止: 2026-03-10      预估: 120分钟                  │
│                                                        │
│  标签: [工作] [重要] [API]                             │
│                                                        │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                                        │
│  📝 任务描述                                           │
│  设计RESTful API接口，包括用户模块、任务模块、         │
│  游戏化系统等核心功能的API定义。                        │
│                                                        │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                                        │
│  📋 详细内容 (Markdown)                                │
│  ┌────────────────────────────────────────────────┐  │
│  │ # API设计任务                                   │  │
│  │                                                │  │
│  │ ## 背景说明                                    │  │
│  │ - 为什么需要做这个任务...                      │  │
│  │                                                │  │
│  │ ## 行动计划                                    │  │
│  │ 1. 定义API规范                                 │  │
│  │ 2. 设计数据结构                                │  │
│  │ 3. 编写API文档                                 │  │
│  │                                                │  │
│  │ ## Checklist                                   │  │
│  │ - [x] 用户模块API                              │  │
│  │ - [ ] 任务模块API                              │  │
│  │ - [ ] 游戏化API                                │  │
│  └────────────────────────────────────────────────┘  │
│                                                        │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                                        │
│  [编辑Markdown]  [完成任务]                            │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

### 3.3 数据分析页

#### 页面布局

```
┌────────────────────────────────────────────────────────┐
│  📊 数据分析                                           │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ┌────────────────────────────────────────────────┐  │
│  │  📅 今日简报 - 2026年3月8日                     │  │
│  │                                                │  │
│  │  昨日回顾:                                      │  │
│  │  ✅ 完成任务：8个                               │  │
│  │  ⏰ 平均时长：45分钟                            │  │
│  │  🎯 四象限分布：2/5/1/0                         │  │
│  │                                                │  │
│  │  关键发现:                                      │  │
│  │  • 你上午完成了3个第二象限任务，效率最高        │  │
│  │  • 本周第二象限任务占比提升15%                 │  │
│  │                                                │  │
│  │  今日建议:                                      │  │
│  │  • 适合安排一个90分钟的深度工作块              │  │
│  └────────────────────────────────────────────────┘  │
│                                                        │
│  ┌───────────────┐  ┌───────────────┐                │
│  │  XP趋势图     │  │  四象限分布   │                │
│  │  [折线图]     │  │  [饼图]       │                │
│  └───────────────┘  └───────────────┘                │
│                                                        │
│  ┌───────────────┐  ┌───────────────┐                │
│  │  属性雷达图   │  │  成就进度     │                │
│  │  [雷达图]     │  │  [进度条]     │                │
│  └───────────────┘  └───────────────┘                │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

## 4. 组件设计规范

### 4.1 按钮组件

#### 主按钮 (Primary Button)

```html
<button class="btn-primary">
  创建任务
</button>
```

```css
.btn-primary {
  /* 背景 */
  background: linear-gradient(135deg, #6366F1 0%, #4F46E5 100%);
  color: white;

  /* 尺寸 */
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;

  /* 圆角 */
  border-radius: 0.5rem;

  /* 过渡 */
  transition: all 0.2s;

  /* 阴影 */
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
}

.btn-primary:hover {
  background: linear-gradient(135deg, #4F46E5 0%, #4338CA 100%);
  transform: translateY(-1px);
  box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1);
}

.btn-primary:active {
  transform: translateY(0);
}
```

---

### 4.2 输入框组件

```html
<div class="input-group">
  <label class="input-label">任务标题</label>
  <input
    type="text"
    class="input-field"
    placeholder="输入任务标题..."
  />
  <span class="input-hint">最多255个字符</span>
</div>
```

```css
.input-label {
  display: block;
  font-size: 0.875rem;
  font-weight: 500;
  color: #374151;
  margin-bottom: 0.5rem;
}

.input-field {
  width: 100%;
  padding: 0.75rem 1rem;
  font-size: 1rem;
  border: 1px solid #D1D5DB;
  border-radius: 0.5rem;
  transition: all 0.2s;
}

.input-field:focus {
  outline: none;
  border-color: #6366F1;
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}

.input-hint {
  display: block;
  margin-top: 0.25rem;
  font-size: 0.75rem;
  color: #6B7280;
}
```

---

### 4.3 卡片组件

```html
<div class="card">
  <div class="card-header">
    <h3 class="card-title">任务标题</h3>
    <span class="card-badge">进行中</span>
  </div>
  <div class="card-body">
    <p class="card-text">任务描述...</p>
  </div>
  <div class="card-footer">
    <button class="btn-secondary">取消</button>
    <button class="btn-primary">确认</button>
  </div>
</div>
```

```css
.card {
  background: white;
  border-radius: 1rem;
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  overflow: hidden;
}

.card-header {
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #E5E7EB;
}

.card-title {
  font-size: 1.125rem;
  font-weight: 600;
  color: #111827;
}

.card-body {
  padding: 1.5rem;
}

.card-footer {
  padding: 1rem 1.5rem;
  border-top: 1px solid #E5E7EB;
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
}
```

---

## 5. 交互动画设计

### 5.1 任务完成动画

```
用户点击"完成任务"
  ↓
任务卡片缩小 + 淡出 (300ms)
  ↓
XP 数字从卡片飞向顶部 XP 显示 (500ms)
  ↓
顶部 XP 数字跳动更新 (200ms)
  ↓
如果升级，显示全屏庆祝动画 (1000ms)
  ↓
如果有新成就，显示成就弹窗 (持续显示)
```

#### 实现代码

```vue
<template>
  <transition
    @before-enter="beforeEnter"
    @enter="enter"
    @leave="leave"
  >
    <div v-if="showXPFly" class="xp-fly">
      +{{ xpEarned }} XP
    </div>
  </transition>
</template>

<script setup>
import { ref } from 'vue'

function beforeEnter(el) {
  el.style.transform = 'translateY(0) scale(1)'
  el.style.opacity = '1'
}

function enter(el, done) {
  // XP 飞向顶部
  el.animate([
    { transform: 'translateY(0) scale(1)', opacity: 1 },
    { transform: 'translateY(-100px) scale(1.5)', opacity: 0 }
  ], {
    duration: 500,
    easing: 'ease-out'
  }).onfinish = done
}

function leave(el, done) {
  el.style.opacity = '0'
  done()
}
</script>
```

---

### 5.2 等级提升动画

```
触发升级
  ↓
全屏遮罩淡入 (200ms)
  ↓
等级徽章从中心放大弹入 (500ms, 弹性动画)
  ↓
粒子特效从中心向外扩散 (1000ms)
  ↓
新等级称号淡入 (300ms)
  ↓
等待用户点击"太棒了！"按钮
  ↓
遮罩淡出，返回任务视图 (300ms)
```

---

### 5.3 成就解锁动画

```
成就解锁
  ↓
从屏幕右侧滑入 Toast 通知 (300ms)
  ↓
成就图标旋转 + 闪光效果 (500ms)
  ↓
显示成就名称和描述 (300ms)
  ↓
自动消失或用户关闭 (5000ms后)
```

---

## 6. 响应式设计

### 6.1 断点定义

```css
/* 移动端 */
@media (max-width: 639px) { /* xs */ }

/* 平板 */
@media (min-width: 640px) and (max-width: 1023px) { /* sm - md */ }

/* 桌面 */
@media (min-width: 1024px) { /* lg+ */ }
```

### 6.2 移动端适配

#### 四象限布局调整

**桌面端**: 2x2 网格
**移动端**: 垂直堆叠，每个象限占满宽度

```css
/* 桌面端 */
.quadrant-view {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}

/* 移动端 */
@media (max-width: 639px) {
  .quadrant-view {
    grid-template-columns: 1fr;
  }
}
```

---

### 6.3 触摸优化

```css
/* 增加触摸目标大小 */
@media (pointer: coarse) {
  .btn, .task-card {
    min-height: 48px;
    min-width: 48px;
  }
}
```

---

## 7. 文案设计规范

### 7.1 文案语气

**核心原则**: 理解我、帮助我、不评判我

#### 文案对比

| 场景 | ❌ 避免的文案 | ✅ 推荐的文案 |
|------|-------------|-------------|
| 连击断裂 | "你的连击已中断" | "欢迎回来！新连击从1开始" |
| 进度落后 | "你落后了15%" | "这周确实很忙，我帮你调整计划" |
| 任务逾期 | "你逾期了3个任务" | "有3个任务需要重新安排时间" |
| 四象限失衡 | "第一象限占比过高" | "近期紧急任务较多，注意保护成长时间" |

---

### 7.2 按钮文案

```css
/* 操作按钮 */
- 创建任务 (不是"新建任务")
- 开始执行 (不是"执行")
- 完成任务 (不是"完成")
- 保存更改 (不是"保存")

/* 确认按钮 */
- 太棒了！
- 知道了
- 继续加油
- 开始挑战
```

---

### 7.3 提示文案

```css
/* 成功提示 */
- "任务已完成，获得 48 XP！" (不是"任务已完成")
- "连续7天！你太棒了！" (不是"连击天数：7")
- "升级！你现在是 Lv.5 时间学徒" (不是"等级提升至5")

/* 鼓励文案 */
- "加油，你快完成今日目标了！"
- "休息一下，明天继续！"
- "你已经走了很远，继续保持！"
```

---

## 8. 图标与插图

### 8.1 图标使用

**图标库**: Heroicons (https://heroicons.com/)

**图标风格**: Solid (实心) / Outline (线性)

**常用图标**:
- 🔥 FireIcon - 第一象限
- 🌱 SparklesIcon - 第二象限
- ⚡ BoltIcon - 第三象限
- 🎮 PuzzlePieceIcon - 第四象限
- ⭐ StarIcon - 难度
- 🏆 TrophyIcon - 成就
- 📈 ChartBarIcon - 数据分析
- ⚙️ CogIcon - 设置

---

### 8.2 插图设计

**插图风格**: 简约线条风格，与整体设计风格一致

**使用场景**:
- 空状态提示（无任务时）
- 成就解锁插图
- 等级提升插图
- 错误页面插图

---

## 9. 可访问性 (Accessibility)

### 9.1 对比度

- ✅ 所有文本与背景对比度 ≥ 4.5:1
- ✅ 大文本对比度 ≥ 3:1

### 9.2 键盘导航

- ✅ 所有交互元素可通过 Tab 键访问
- ✅ 支持 Enter/Space 键激活按钮
- ✅ 支持 Esc 键关闭弹窗

### 9.3 屏幕阅读器

```html
<!-- 使用语义化标签 -->
<button aria-label="创建新任务">
  <PlusIcon class="w-5 h-5" />
</button>

<!-- 状态提示 -->
<div role="status" aria-live="polite">
  任务已完成
</div>
```

---

## 10. 性能优化

### 10.1 图片优化

- ✅ 使用 WebP 格式
- ✅ 实现懒加载
- ✅ 使用响应式图片

### 10.2 动画性能

```css
/* 使用 GPU 加速 */
.xp-fly {
  will-change: transform;
  transform: translateZ(0);
}

/* 避免重排 */
.card:hover {
  transform: translateY(-2px); /* ✅ */
  /* top: -2px; ❌ 会触发重排 */
}
```

---

**文档结束**

> 本 UI/UX 设计文档将根据项目进展持续更新。