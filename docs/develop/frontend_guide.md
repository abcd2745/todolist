# 前端开发指南

**版本**: v2.0
**日期**: 2026-03-08
**负责人**: Claude Code

---

## 📋 概述

本文档提供前端开发的详细指南，包括组件设计、样式规范、交互逻辑等。

---

## 🎨 设计系统脚本

### 1. 颜色生成脚本

```javascript
/**
 * 设计系统颜色配置
 * 基于简约清新风格
 */
const colorSystem = {
  // 背景色
  background: {
    primary: '#f8fafc',      // 主背景
    secondary: '#ffffff',     // 卡片背景
    tertiary: '#f1f5f9'       // 输入框/按钮背景
  },

  // 主题色
  theme: {
    primary: '#64748b',       // 主色调（石板灰）
    secondary: '#475569',     // 辅色调
    accent: '#1e293b'         // 强调色
  },

  // 功能色
  functional: {
    success: '#059669',
    warning: '#f59e0b',
    danger: '#ef4444',
    info: '#3b82f6'
  },

  // 四象限配色（柔和版）
  quadrants: {
    q1: {
      primary: '#ef4444',     // 紧急且重要
      background: '#fee2e2',
      border: '#fecaca'
    },
    q2: {
      primary: '#3b82f6',     // 重要不紧急
      background: '#dbeafe',
      border: '#bfdbfe'
    },
    q3: {
      primary: '#f59e0b',     // 紧急不重要
      background: '#fef3c7',
      border: '#fde68a'
    },
    q4: {
      primary: '#10b981',     // 不紧急不重要
      background: '#d1fae5',
      border: '#a7f3d0'
    }
  }
};

// 导出颜色变量
export default colorSystem;
```

---

### 2. 四象限布局脚本

```javascript
/**
 * 四象限坐标轴布局系统
 * 使用绝对定位实现坐标轴布局
 */
class QuadrantLayout {
  constructor(container) {
    this.container = container;
    this.quadrants = {};
    this.init();
  }

  init() {
    this.createAxes();
    this.createLabels();
    this.createQuadrants();
  }

  createAxes() {
    // X轴
    const axisX = document.createElement('div');
    axisX.className = 'axis axis-x';
    Object.assign(axisX.style, {
      position: 'absolute',
      width: 'calc(100% - 80px)',
      height: '2px',
      left: '40px',
      top: '50%',
      transform: 'translateY(-50%)',
      background: '#e2e8f0'
    });

    // Y轴
    const axisY = document.createElement('div');
    axisY.className = 'axis axis-y';
    Object.assign(axisY.style, {
      position: 'absolute',
      width: '2px',
      height: 'calc(100% - 80px)',
      left: '50%',
      top: '40px',
      transform: 'translateX(-50%)',
      background: '#e2e8f0'
    });

    this.container.appendChild(axisX);
    this.container.appendChild(axisY);
  }

  createLabels() {
    const labels = [
      { text: '↑ 重要', className: 'top', position: { top: '20px', left: '50%', transform: 'translateX(-50%)' } },
      { text: '↓ 不重要', className: 'bottom', position: { bottom: '20px', left: '50%', transform: 'translateX(-50%)' } },
      { text: '← 不紧急', className: 'left', position: { left: '20px', top: '50%', transform: 'translateY(-50%)' } },
      { text: '紧急 →', className: 'right', position: { right: '20px', top: '50%', transform: 'translateY(-50%)' } }
    ];

    labels.forEach(label => {
      const el = document.createElement('div');
      el.className = `axis-label ${label.className}`;
      el.textContent = label.text;
      Object.assign(el.style, {
        position: 'absolute',
        fontSize: '13px',
        fontWeight: '500',
        color: '#64748b',
        background: 'white',
        padding: '4px 8px',
        ...label.position
      });
      this.container.appendChild(el);
    });
  }

  createQuadrants() {
    const positions = {
      q1: { top: '40px', right: '40px' },      // 右上
      q2: { top: '40px', left: '40px' },       // 左上
      q3: { bottom: '40px', right: '40px' },   // 右下
      q4: { bottom: '40px', left: '40px' }     // 左下
    };

    Object.keys(positions).forEach(q => {
      const quadrant = document.createElement('div');
      quadrant.className = `quadrant ${q}`;
      Object.assign(quadrant.style, {
        position: 'absolute',
        width: 'calc(50% - 60px)',
        height: 'calc(50% - 60px)',
        padding: '20px',
        overflowY: 'auto',
        ...positions[q]
      });
      this.quadrants[q] = quadrant;
      this.container.appendChild(quadrant);
    });
  }

  addTask(quadrant, task) {
    const q = this.quadrants[quadrant];
    if (!q) return;

    const taskCard = this.createTaskCard(task);
    q.appendChild(taskCard);
  }

  createTaskCard(task) {
    const card = document.createElement('div');
    card.className = `task-card ${task.quadrant}`;
    // ... 创建任务卡片逻辑
    return card;
  }
}

// 使用示例
// const layout = new QuadrantLayout(document.querySelector('.quadrant-container'));
// layout.addTask('q1', { title: '完成任务', quadrant: 'q1' });

export default QuadrantLayout;
```

---

### 3. 动画系统脚本

```javascript
/**
 * 简约动画系统
 * 提供流畅、简洁的动画效果
 */
class AnimationSystem {
  // XP飞入动画
  static animateXP(element, from, to, duration = 500) {
    const animation = element.animate([
      { transform: `translate(${from.x}px, ${from.y}px)`, opacity: 1 },
      { transform: `translate(${to.x}px, ${to.y}px)`, opacity: 0 }
    ], {
      duration: duration,
      easing: 'ease-out'
    });

    return animation.finished;
  }

  // 任务完成动画
  static completeTask(element) {
    const animation = element.animate([
      { transform: 'scale(1)', opacity: 1 },
      { transform: 'scale(0.95)', opacity: 0.5 },
      { transform: 'scale(0)', opacity: 0 }
    ], {
      duration: 300,
      easing: 'ease-out'
    });

    return animation.finished;
  }

  // 卡片悬停动画
  static hoverCard(element, isHover) {
    element.style.transition = 'all 0.2s ease';
    if (isHover) {
      element.style.transform = 'translateX(2px)';
      element.style.background = '#f1f5f9';
    } else {
      element.style.transform = 'translateX(0)';
      element.style.background = '#f8fafc';
    }
  }

  // Toast通知动画
  static showToast(title, message) {
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerHTML = `
      <div class="toast-icon">🎉</div>
      <div class="toast-content">
        <div class="toast-title">${title}</div>
        <div class="toast-message">${message}</div>
      </div>
    `;

    document.body.appendChild(toast);

    // 自动消失
    setTimeout(() => {
      toast.style.animation = 'fadeOut 0.3s';
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }
}

export default AnimationSystem;
```

---

## 🧩 组件设计

### 1. 任务卡片组件

```vue
<!-- TaskCard.vue -->
<template>
  <div
    :class="['task-card', quadrant]"
    @mouseenter="handleHover(true)"
    @mouseleave="handleHover(false)"
  >
    <div class="task-title">{{ title }}</div>
    <div class="task-meta">
      <span>📅 {{ deadline }}</span>
      <span class="stars">{{ stars }}</span>
    </div>
    <div class="task-info">
      <span class="task-xp">+{{ xp }} XP</span>
      <span :class="['task-status', status]">{{ statusText }}</span>
    </div>
    <div class="task-actions">
      <button class="btn btn-success" @click="complete">✓</button>
      <button class="btn btn-primary" @click="edit">✎</button>
      <button class="btn btn-danger" @click="remove">🗑</button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: String,
    deadline: String,
    difficulty: Number,
    quadrant: String,
    status: String,
    xp: Number
  },
  computed: {
    stars() {
      return '⭐'.repeat(this.difficulty);
    },
    statusText() {
      const map = {
        pending: '待办',
        'in-progress': '进行中',
        completed: '已完成'
      };
      return map[this.status];
    }
  },
  methods: {
    handleHover(isHover) {
      AnimationSystem.hoverCard(this.$el, isHover);
    },
    complete() {
      this.$emit('complete', this.$el);
    },
    edit() {
      this.$emit('edit');
    },
    remove() {
      this.$emit('remove');
    }
  }
};
</script>

<style scoped>
.task-card {
  background: #f8fafc;
  border-radius: 8px;
  padding: 14px;
  margin-bottom: 10px;
  border-left: 3px solid;
  transition: all 0.2s;
}

.task-card.q1 { border-color: #ef4444; }
.task-card.q2 { border-color: #3b82f6; }
.task-card.q3 { border-color: #f59e0b; }
.task-card.q4 { border-color: #10b981; }
</style>
```

---

### 2. 四象限容器组件

```vue
<!-- QuadrantContainer.vue -->
<template>
  <div class="quadrant-container">
    <!-- 坐标轴 -->
    <div class="axis axis-x"></div>
    <div class="axis axis-y"></div>

    <!-- 象限标签 -->
    <div class="axis-label top">↑ 重要</div>
    <div class="axis-label bottom">↓ 不重要</div>
    <div class="axis-label left">← 不紧急</div>
    <div class="axis-label right">紧急 →</div>

    <!-- 四个象限 -->
    <div
      v-for="q in ['q1', 'q2', 'q3', 'q4']"
      :key="q"
      :class="['quadrant', q]"
    >
      <div :class="['quadrant-header', q]">
        <span>{{ quadrantIcons[q] }}</span>
        {{ quadrantNames[q] }}
      </div>

      <TaskCard
        v-for="task in getTasks(q)"
        :key="task.id"
        v-bind="task"
        @complete="completeTask"
        @edit="editTask"
        @remove="removeTask"
      />

      <button class="btn-add" @click="addTask(q)">
        + 添加任务
      </button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      quadrantIcons: {
        q1: '🔥',
        q2: '🌱',
        q3: '⚡',
        q4: '🎮'
      },
      quadrantNames: {
        q1: '紧急且重要',
        q2: '重要不紧急',
        q3: '紧急不重要',
        q4: '不紧急不重要'
      }
    };
  },
  methods: {
    getTasks(quadrant) {
      return this.tasks.filter(t => t.quadrant === quadrant);
    },
    addTask(quadrant) {
      this.$emit('add-task', quadrant);
    },
    completeTask(element) {
      // 执行完成动画
      AnimationSystem.completeTask(element).then(() => {
        // 更新XP
        this.$emit('update-xp');
        // 显示通知
        AnimationSystem.showToast('✅ 任务完成', '恭喜获得 XP！');
      });
    }
  }
};
</script>
```

---

## 📱 响应式设计

### 断点系统

```javascript
/**
 * 响应式设计配置
 */
const breakpoints = {
  mobile: '640px',
  tablet: '1024px',
  desktop: '1280px'
};

// 媒体查询
const mediaQueries = {
  mobile: `@media (max-width: ${breakpoints.mobile})`,
  tablet: `@media (min-width: ${breakpoints.mobile}) and (max-width: ${breakpoints.tablet})`,
  desktop: `@media (min-width: ${breakpoints.tablet})`
};

export default mediaQueries;
```

---

## ✅ 开发检查清单

### 样式检查
- [ ] 背景色使用 `#f8fafc`
- [ ] 主题色使用 `#64748b`
- [ ] 四象限配色柔和
- [ ] 阴影使用轻阴影

### 布局检查
- [ ] 四象限使用坐标轴布局
- [ ] 象限标签清晰（重要/不重要/紧急/不紧急）
- [ ] 坐标轴线条清晰可见

### 交互检查
- [ ] 任务卡片悬停效果流畅
- [ ] XP动画自然
- [ ] Toast通知正常显示

### 响应式检查
- [ ] 桌面端坐标轴布局正常
- [ ] 平板端象限尺寸适配
- [ ] 移动端垂直堆叠（可选）

---

**最后更新**: 2026-03-08
**维护者**: Claude Code