# 设计变更记录

**版本**: v2.1
**日期**: 2026-03-08
**负责人**: Claude Code

---

## 📋 变更概述

根据用户反馈，对系统整体设计进行重大调整，从浓重的游戏化风格转变为简约清新风格，并持续优化细节。

---

## 🎨 设计变更详情

### 1. 整体风格变更（v1.0 → v2.0）

#### 变更前 (v1.0)
- **背景**: 紫蓝渐变背景 (`linear-gradient(135deg, #667eea 0%, #764ba2 100%)`)
- **风格**: 浓重、游戏化
- **颜色**: 鲜艳、对比强烈

#### 变更后 (v2.0)
- **背景**: 淡雅灰色 (`#f8fafc`)
- **风格**: 简约、清新、专业
- **颜色**: 柔和、低饱和度

---

### 2. 四象限布局变更（v1.0 → v2.0）

#### 变更前 (v1.0)
```
┌────────────┬────────────┐
│     Q2     │     Q1     │
├────────────┼────────────┤
│     Q4     │     Q3     │
└────────────┴────────────┘
```
- 2x2 网格布局
- 四个象限独立卡片
- 无坐标轴概念

#### 变更后 (v2.0)
```
         重要
          │
     Q2   │   Q1
──────────┼──────────
     Q4   │   Q3
          │
        不重要
   不紧急    紧急
```
- 坐标轴布局
- X轴: 紧急程度（不紧急 → 紧急）
- Y轴: 重要程度（不重要 → 重要）
- 四个象限用坐标轴分隔

---

### 3. 坐标轴美化（v2.0 → v2.1）

#### 变更前 (v2.0)
- 纯色线条（`#cbd5e1`）
- 线条宽度：2px
- 箭头在标签中（"↑ 重要"、"紧急 →"）

#### 变更后 (v2.1)
- 渐变色线条（`linear-gradient`）
- 线条宽度：3px
- 箭头在坐标轴上（更直观）

**渐变效果**：
```css
/* X轴 - 水平渐变 */
background: linear-gradient(to right,
    #94a3b8 0%,
    #cbd5e1 50%,
    #94a3b8 100%);

/* Y轴 - 垂直渐变 */
background: linear-gradient(to bottom,
    #94a3b8 0%,
    #cbd5e1 50%,
    #94a3b8 100%);
```

**箭头位置**：
```
         ↑
         │
  ← ─────┼───── →
         │
         ↓
```
- X轴：左箭头 ← 右箭头 →
- Y轴：上箭头 ↑ 下箭头 ↓

**标签优化**：
- 标签不带箭头：重要、不重要、不紧急、紧急
- 更简洁清晰

---

### 4. 任务卡片按钮优化（v2.0 → v2.1）

#### 变更前 (v2.0)
- 三个独立按钮（完成、编辑、删除）
- 全宽按钮
- 占用空间大

#### 变更后 (v2.1)
- 四个小图标按钮（完成、查看、编辑、删除）
- 24px × 24px
- 右对齐到标题
- 悬停时显示彩色背景

**布局对比**：
```
变更前：
┌────────────────────────────┐
│ 任务标题                   │
│ 📅 03-10  ⭐⭐⭐⭐          │
│ +48 XP  [进行中]           │
│ [完成] [编辑] [删除]       │ ← 独立一行
└────────────────────────────┘

变更后：
┌────────────────────────────┐
│ 任务标题      [✓][👁][✎][🗑]│ ← 与标题同行
│ 📅 03-10  ⭐⭐⭐⭐          │
│ +48 XP  [进行中]           │
└────────────────────────────┘
```

**新增功能**：
- ✓ 完成按钮（绿色悬停）
- 👁 查看按钮（蓝色悬停）← 新增
- ✎ 编辑按钮（黄色悬停）
- 🗑 删除按钮（红色悬停）

---

### 5. 表单验证优化（v2.1）

#### 截止日期验证
- 不能选择过去的日期
- 自动设置 `min` 属性为今天

**实现方式**：
```javascript
// 在打开创建任务弹窗时设置
const today = new Date().toISOString().split('T')[0];
document.getElementById('deadline').min = today;
```

---

## 🎯 设计原则

### 新设计原则 (v2.1)

1. **简约至上**
   - 减少视觉噪音
   - 使用柔和的颜色
   - 保持界面清爽

2. **清晰明确**
   - 坐标轴明确象限含义
   - 箭头直观指示方向
   - 视觉层次分明

3. **专业高效**
   - 适合工作场景
   - 降低视觉疲劳
   - 提升专注度

4. **细节精致**
   - 渐变色美化坐标轴
   - 图标按钮小巧精致
   - 交互反馈流畅

---

## 🎨 设计系统

### 颜色系统 (v2.1)

#### 背景色
```css
主背景: #f8fafc        /* 淡雅灰 */
卡片背景: #ffffff       /* 纯白 */
输入框背景: #ffffff
```

#### 主题色
```css
主色调: #64748b        /* 石板灰 */
辅色调: #475569        /* 深灰 */
强调色: #1e293b        /* 深色 */
```

#### 坐标轴颜色
```css
渐变起点/终点: #94a3b8  /* 中灰 */
渐变中点: #cbd5e1       /* 浅灰 */
```

#### 功能色
```css
成功: #059669          /* 绿色 */
警告: #f59e0b          /* 橙色 */
危险: #ef4444          /* 红色 */
信息: #3b82f6          /* 蓝色 */
```

#### 四象限配色（柔和版）
```css
Q1 (紧急且重要): #ef4444 / #fecaca
Q2 (重要不紧急): #3b82f6 / #bfdbfe
Q3 (紧急不重要): #f59e0b / #fde68a
Q4 (不紧急不重要): #10b981 / #a7f3d0
```

---

### 字体系统 (v2.1)

```css
主字体: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto

标题:
  - H1: 28px / 600
  - H2: 20px / 600
  - H3: 16px / 600

正文:
  - Body: 14px / 400
  - Small: 11px / 400

轴标签: 15px / 600
```

---

### 间距系统 (v2.1)

```css
容器间距: 20px
卡片内边距: 24px / 28px / 60px
元素间距: 6px / 8px / 10px / 12px / 16px
圆角: 8px / 12px
```

---

### 阴影系统 (v2.1)

```css
轻阴影: 0 1px 3px rgba(0, 0, 0, 0.05)
中阴影: 0 4px 6px rgba(0, 0, 0, 0.1)
重阴影: 0 8px 16px rgba(0, 0, 0, 0.15)
```

---

## 📊 布局系统

### 主页布局 (v2.1)

```html
<!-- 坐标轴容器 -->
<div class="quadrant-container">
  <!-- 渐变色坐标轴 -->
  <div class="axis axis-x"></div>  <!-- 带 ← → 箭头 -->
  <div class="axis axis-y"></div>  <!-- 带 ↑ ↓ 箭头 -->

  <!-- 象限标签（不带箭头） -->
  <div class="axis-label top">重要</div>
  <div class="axis-label bottom">不重要</div>
  <div class="axis-label left">不紧急</div>
  <div class="axis-label right">紧急</div>

  <!-- 四个象限 -->
  <div class="quadrant q1">...</div>  <!-- 右上 -->
  <div class="quadrant q2">...</div>  <!-- 左上 -->
  <div class="quadrant q3">...</div>  <!-- 右下 -->
  <div class="quadrant q4">...</div>  <!-- 左下 -->
</div>
```

### 象限定位

```css
.quadrant {
    position: absolute;
    padding: 24px;
    overflow-y: auto;
}

/* Q1: 右上 - 紧急且重要 */
.quadrant.q1 {
    top: 60px;
    right: 60px;
    width: calc(50% - 84px);
    height: calc(50% - 84px);
}

/* Q2: 左上 - 重要不紧急 */
.quadrant.q2 {
    top: 60px;
    left: 60px;
    width: calc(50% - 84px);
    height: calc(50% - 84px);
}

/* Q3: 右下 - 紧急不重要 */
.quadrant.q3 {
    bottom: 60px;
    right: 60px;
    width: calc(50% - 84px);
    height: calc(50% - 84px);
}

/* Q4: 左下 - 不紧急不重要 */
.quadrant.q4 {
    bottom: 60px;
    left: 60px;
    width: calc(50% - 84px);
    height: calc(50% - 84px);
}
```

---

## 🔄 迁移指南

### 从 v2.0 迁移到 v2.1

#### 1. 更新坐标轴样式
```css
/* v2.0 */
.axis {
    background: #cbd5e1;
    height: 2px;
}

/* v2.1 */
.axis-x {
    height: 3px;
    background: linear-gradient(to right,
        #94a3b8 0%, #cbd5e1 50%, #94a3b8 100%);
}

.axis-x::after {
    content: '→';
    position: absolute;
    right: -8px;
}
```

#### 2. 更新轴标签
```html
<!-- v2.0 -->
<div class="axis-label top">↑ 重要</div>

<!-- v2.1 -->
<div class="axis-label top">重要</div>
```

#### 3. 优化任务卡片按钮
```html
<!-- v2.0 -->
<div class="task-actions">
    <button class="btn btn-success">完成</button>
    <button class="btn btn-primary">编辑</button>
    <button class="btn btn-danger">删除</button>
</div>

<!-- v2.1 -->
<div class="task-header">
    <div class="task-title">任务标题</div>
    <div class="task-actions">
        <button class="action-btn complete">✓</button>
        <button class="action-btn view">👁</button>
        <button class="action-btn edit">✎</button>
        <button class="action-btn delete">🗑</button>
    </div>
</div>
```

#### 4. 添加日期验证
```javascript
// 打开创建任务弹窗时
const today = new Date().toISOString().split('T')[0];
document.getElementById('deadline').min = today;
```

---

## 📝 更新的页面

### 已完成
- ✅ `home.html` - 主页（坐标轴布局、渐变色美化、箭头优化）
- ✅ `login.html` - 登录页面（简约风格）
- ✅ `register.html` - 注册页面（简约风格）

### 待更新
- ⏳ `task-detail.html` - 任务详情页
- ⏳ `analytics.html` - 数据分析页
- ⏳ `achievements.html` - 成就展示页

---

## 🎯 设计目标

### 用户体验目标
1. **降低视觉疲劳**: 淡雅背景，柔和配色
2. **提升专业感**: 简约设计，清晰布局
3. **增强可用性**: 坐标轴直观展示四象限含义
4. **提高效率**: 清晰的信息层次，快速定位任务
5. **细节精致**: 渐变色美化，图标按钮精致

---

## ✅ 验收标准

### 视觉验收
- [x] 背景色淡雅，不刺眼
- [x] 配色和谐，对比度适中
- [x] 四象限用坐标轴清晰分隔
- [x] 坐标轴渐变色美观
- [x] 箭头在坐标轴上，标签不带箭头

### 功能验收
- [x] 任务可以在四个象限中正确显示
- [x] 任务卡片按钮小巧精致
- [x] 创建任务表单功能正常
- [x] 截止日期不能选择过去

### 响应式验收
- [x] 桌面端布局正常（≥1024px）
- [x] 平板端布局适配（640-1023px）
- [x] 移动端布局优化（<640px）

---

**最后更新**: 2026-03-08
**维护者**: Claude Code