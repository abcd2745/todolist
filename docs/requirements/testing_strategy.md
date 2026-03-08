# 游戏化待办事项系统 - 测试策略文档

**文档版本**: v1.0
**创建日期**: 2026-03-07
**负责人**: QA Lead
**状态**: 初稿

---

## 文档修订记录

| 版本 | 日期 | 修改人 | 修改内容 |
|------|------|--------|----------|
| v1.0 | 2026-03-07 | QA Lead | 初始版本 |

---

## 目录

1. [测试策略概述](#1-测试策略概述)
2. [测试层次与范围](#2-测试层次与范围)
3. [质量门禁](#3-质量门禁)
4. [测试覆盖率要求](#4-测试覆盖率要求)
5. [游戏化逻辑测试](#5-游戏化逻辑测试)
6. [AI 任务拆分测试](#6-ai-任务拆分测试)
7. [数据分析测试](#7-数据分析测试)
8. [性能测试](#8-性能测试)
9. [离线与同步测试](#9-离线与同步测试)
10. [兼容性测试](#10-兼容性测试)
11. [安全测试](#11-安全测试)
12. [UAT 测试方案](#12-uat-测试方案)
13. [测试环境与工具](#13-测试环境与工具)
14. [风险与缓解措施](#14-风险与缓解措施)

---

## 1. 测试策略概述

### 1.1 测试目标

确保游戏化待办事项系统满足以下核心目标：

1. **功能正确性** - 所有功能按需求文档正确实现
2. **数据准确性** - 数据分析、洞察生成准确可靠
3. **性能达标** - 响应时间、加载速度符合非功能需求
4. **用户体验** - 符合"理解我、帮助我、不评判我"的产品理念
5. **安全性** - 用户数据安全，隐私保护到位
6. **可靠性** - 离线支持、数据同步稳定可靠

### 1.2 测试原则

| 原则 | 说明 |
|------|------|
| 自动化优先 | 80% 以上的测试用例自动化，CI/CD 集成 |
| 数据驱动测试 | 使用真实场景数据生成测试用例 |
| 边界值测试 | 重点测试边界条件和异常情况 |
| 用户视角测试 | 从用户真实使用场景设计测试 |
| 持续测试 | 每次提交触发自动化测试 |

### 1.3 测试金字塔

```
          /\         E2E Tests (10%)
         /  \        - 核心用户流程
        /----\
       /      \      Integration Tests (20%)
      /        \     - API 集成、数据流、组件交互
     /----------\
    /            \   Unit Tests (70%)
   /              \  - 业务逻辑、计算公式、工具函数
  /----------------\
```

---

## 2. 测试层次与范围

### 2.1 单元测试 (Unit Testing)

**覆盖范围**:
- XP 计算逻辑
- 等级升级规则
- 连击系统计算
- 四象限分类算法
- 属性系统计算
- 成就解锁逻辑
- 数据聚合函数
- 时间格式转换工具

**工具**: Jest (前端) / Pytest (后端)

### 2.2 集成测试 (Integration Testing)

**覆盖范围**:
- API 端点集成测试
- 数据库 CRUD 操作
- AI 服务集成
- 数据采集与存储流程
- 用户认证流程
- 数据同步机制

**工具**: Supertest (API) / Pytest (后端)

### 2.3 E2E 测试 (End-to-End Testing)

**覆盖范围**:
- 用户注册/登录流程
- 任务创建到完成流程
- 长任务创建与 AI 拆分
- 数据报告生成与查看
- 游戏/专业模式切换
- 离线使用与同步

**工具**: Playwright / Cypress

### 2.4 性能测试 (Performance Testing)

**覆盖范围**:
- 页面加载时间
- API 响应时间
- 数据报告生成速度
- 并发用户支持
- 大数据量处理

**工具**: Artillery / k6 / Lighthouse

### 2.5 兼容性测试 (Compatibility Testing)

**覆盖范围**:
- 浏览器兼容性 (Chrome, Firefox, Safari, Edge)
- 移动端适配 (iOS Safari, Android Chrome)
- 屏幕尺寸适配 (桌面、平板、手机)
- 离线模式兼容性

**工具**: BrowserStack / Sauce Labs

---

## 3. 质量门禁

### 3.1 P0 阶段质量门禁 (MVP - Week 1-4)

| 指标 | 要求 | 测量方式 |
|------|------|----------|
| 代码覆盖率 | ≥ 80% | Jest / Pytest 覆盖率报告 |
| 单元测试通过率 | 100% | CI/CD 自动化测试 |
| 集成测试通过率 | 100% | CI/CD 自动化测试 |
| E2E 测试通过率 | ≥ 95% | Playwright 测试报告 |
| 页面加载时间 | < 2 秒 | Lighthouse 性能测试 |
| 任务创建响应 | < 500ms | API 响应时间监控 |
| P0 功能缺陷 | 0 个 | Bug 跟踪系统 |
| P1 功能缺陷 | ≤ 5 个 | Bug 跟踪系统 |
| 自动化测试覆盖率 | ≥ 70% | 自动化测试用例占比 |

**发布标准**:
- ✅ 所有 P0 功能测试通过
- ✅ 代码覆盖率达标
- ✅ 无 P0/P1 级别缺陷
- ✅ 性能指标达标
- ✅ UAT 测试通过

### 3.2 P1 阶段质量门禁 (增强体验 - Week 5-8)

| 指标 | 要求 | 测量方式 |
|------|------|----------|
| 代码覆盖率 | ≥ 85% | Jest / Pytest 覆盖率报告 |
| 单元测试通过率 | 100% | CI/CD 自动化测试 |
| 集成测试通过率 | 100% | CI/CD 自动化测试 |
| E2E 测试通过率 | 100% | Playwright 测试报告 |
| 数据报告生成 | < 5 秒 | 周报生成性能测试 |
| P0 功能缺陷 | 0 个 | Bug 跟踪系统 |
| P1 功能缺陷 | ≤ 3 个 | Bug 跟踪系统 |
| 新增功能自动化 | ≥ 80% | 自动化测试用例占比 |

**发布标准**:
- ✅ 所有 P1 功能测试通过
- ✅ 回归测试无新增缺陷
- ✅ AI 拆分准确率 ≥ 80%
- ✅ 数据分析准确率 ≥ 95%

### 3.3 P2 阶段质量门禁 (深度分析 - Week 9-12)

| 指标 | 要求 | 测量方式 |
|------|------|----------|
| 代码覆盖率 | ≥ 90% | Jest / Pytest 覆盖率报告 |
| 单元测试通过率 | 100% | CI/CD 自动化测试 |
| 集成测试通过率 | 100% | CI/CD 自动化测试 |
| E2E 测试通过率 | 100% | Playwright 测试报告 |
| 月度报告生成 | < 10 秒 | 复杂报告性能测试 |
| P0 功能缺陷 | 0 个 | Bug 跟踪系统 |
| P1 功能缺陷 | 0 个 | Bug 跟踪系统 |
| 预测模型准确率 | ≥ 75% | 机器学习模型评估 |

**发布标准**:
- ✅ 所有 P2 功能测试通过
- ✅ 性能无退化
- ✅ 数据预测准确率达标

---

## 4. 测试覆盖率要求

### 4.1 整体覆盖率目标

| 测试类型 | 覆盖率目标 | 优先级 |
|----------|------------|--------|
| 单元测试 | ≥ 80% | P0 |
| 集成测试 | ≥ 70% | P0 |
| E2E 测试 | 核心流程 100% | P0 |
| 性能测试 | 关键接口 100% | P1 |
| 兼容性测试 | 主流浏览器 100% | P0 |

### 4.2 核心模块覆盖率要求

| 模块 | 单元测试 | 集成测试 | E2E 测试 |
|------|----------|----------|----------|
| XP 计算引擎 | 100% | 80% | - |
| 等级系统 | 100% | 80% | - |
| 连击系统 | 100% | 100% | 100% |
| 四象限分类 | 100% | 80% | 100% |
| 属性系统 | 100% | 80% | - |
| 成就系统 | 100% | 80% | 80% |
| AI 拆分 | 80% | 100% | 100% |
| 数据采集 | 80% | 100% | 100% |
| 数据分析 | 90% | 100% | 80% |
| 用户认证 | 80% | 100% | 100% |

### 4.3 覆盖率测量工具

**前端**:
```bash
jest --coverage --coverageThreshold='{"global":{"branches":80,"functions":80,"lines":80,"statements":80}}'
```

**后端**:
```bash
pytest --cov=src --cov-report=html --cov-fail-under=80
```

---

## 5. 游戏化逻辑测试

### 5.1 XP 计算测试

#### 5.1.1 基础 XP 计算

**测试场景**: 验证基础 XP = 任务难度 × 10

```javascript
describe('XP Calculation - Base XP', () => {
  test('难度 1 星任务应获得 10 XP', () => {
    const result = calculateBaseXP(1);
    expect(result).toBe(10);
  });

  test('难度 5 星任务应获得 50 XP', () => {
    const result = calculateBaseXP(5);
    expect(result).toBe(50);
  });

  test('难度 0 星应返回 0 XP', () => {
    const result = calculateBaseXP(0);
    expect(result).toBe(0);
  });

  test('难度超出范围应抛出异常', () => {
    expect(() => calculateBaseXP(6)).toThrow('Invalid difficulty');
    expect(() => calculateBaseXP(-1)).toThrow('Invalid difficulty');
  });
});
```

#### 5.1.2 四象限加成计算

**测试场景**: 验证四象限加成正确应用

```javascript
describe('XP Calculation - Quadrant Bonus', () => {
  test('第一象限任务应有 +20% 加成', () => {
    const baseXP = 30;
    const result = applyQuadrantBonus(baseXP, 1);
    expect(result).toBe(36); // 30 * 1.2
  });

  test('第二象限任务应有 +30% 加成', () => {
    const baseXP = 30;
    const result = applyQuadrantBonus(baseXP, 2);
    expect(result).toBe(39); // 30 * 1.3
  });

  test('第三象限任务应有 +10% 加成', () => {
    const baseXP = 30;
    const result = applyQuadrantBonus(baseXP, 3);
    expect(result).toBe(33); // 30 * 1.1
  });

  test('第四象限任务应有 +5% 加成', () => {
    const baseXP = 30;
    const result = applyQuadrantBonus(baseXP, 4);
    expect(result).toBe(31.5); // 30 * 1.05
  });

  test('无效象限应抛出异常', () => {
    expect(() => applyQuadrantBonus(30, 5)).toThrow('Invalid quadrant');
  });
});
```

#### 5.1.3 连击奖励计算

**测试场景**: 验证连击奖励正确应用

```javascript
describe('XP Calculation - Streak Bonus', () => {
  test('连击 3 天应有 +5% 奖励', () => {
    const baseXP = 30;
    const result = applyStreakBonus(baseXP, 3);
    expect(result).toBe(31.5); // 30 * 1.05
  });

  test('连击 7 天应有 +15% 奖励', () => {
    const baseXP = 30;
    const result = applyStreakBonus(baseXP, 7);
    expect(result).toBe(34.5); // 30 * 1.15
  });

  test('连击 30 天应有 +50% 奖励', () => {
    const baseXP = 30;
    const result = applyStreakBonus(baseXP, 30);
    expect(result).toBe(45); // 30 * 1.5
  });

  test('连击 0 天无奖励', () => {
    const baseXP = 30;
    const result = applyStreakBonus(baseXP, 0);
    expect(result).toBe(30);
  });

  test('连击 2 天无奖励', () => {
    const baseXP = 30;
    const result = applyStreakBonus(baseXP, 2);
    expect(result).toBe(30);
  });

  test('连击 6 天应使用 3 天奖励', () => {
    const baseXP = 30;
    const result = applyStreakBonus(baseXP, 6);
    expect(result).toBe(31.5); // 30 * 1.05
  });
});
```

#### 5.1.4 综合 XP 计算

**测试场景**: 验证基础 XP + 四象限加成 + 连击奖励的组合计算

```javascript
describe('XP Calculation - Total XP', () => {
  test('难度 3 星 + 第二象限 + 7 天连击', () => {
    const difficulty = 3;
    const quadrant = 2;
    const streak = 7;

    const result = calculateTotalXP(difficulty, quadrant, streak);
    // Base: 30, Quadrant: 30 * 1.3 = 39, Streak: 39 * 1.15 = 44.85
    expect(result).toBeCloseTo(44.85, 2);
  });

  test('难度 5 星 + 第一象限 + 30 天连击', () => {
    const difficulty = 5;
    const quadrant = 1;
    const streak = 30;

    const result = calculateTotalXP(difficulty, quadrant, streak);
    // Base: 50, Quadrant: 50 * 1.2 = 60, Streak: 60 * 1.5 = 90
    expect(result).toBe(90);
  });
});
```

### 5.2 等级系统测试

#### 5.2.1 等级计算

**测试场景**: 验证 XP 与等级的正确对应关系

```javascript
describe('Level System', () => {
  test('0 XP 应为等级 1', () => {
    const result = calculateLevel(0);
    expect(result).toBe(1);
  });

  test('100 XP 应为等级 2', () => {
    const result = calculateLevel(100);
    expect(result).toBe(2);
  });

  test('边界值：升级所需 XP', () => {
    const level2Threshold = getXPForLevel(2);
    const level3Threshold = getXPForLevel(3);

    expect(calculateLevel(level2Threshold - 1)).toBe(1);
    expect(calculateLevel(level2Threshold)).toBe(2);
    expect(calculateLevel(level3Threshold - 1)).toBe(2);
    expect(calculateLevel(level3Threshold)).toBe(3);
  });

  test('等级头衔正确映射', () => {
    expect(getLevelTitle(1)).toBe('新手冒险者');
    expect(getLevelTitle(5)).toBe('时间学徒');
    expect(getLevelTitle(6)).toBe('时间管理者');
    expect(getLevelTitle(10)).toBe('成就收集者');
    expect(getLevelTitle(20)).toBe('四象限大师');
  });
});
```

### 5.3 连击系统测试

#### 5.3.1 连击计算

**测试场景**: 验证连击天数的正确计算

```javascript
describe('Streak System', () => {
  test('首次完成任务，连击应为 1', () => {
    const history = [];
    const result = calculateStreak(history);
    expect(result).toBe(1);
  });

  test('连续 7 天完成任务，连击应为 7', () => {
    const history = generateConsecutiveDays(7);
    const result = calculateStreak(history);
    expect(result).toBe(7);
  });

  test('断签后连击重置为 0', () => {
    const history = generateStreakWithGap(7, 1); // 7 天连击后中断 1 天
    const result = calculateStreak(history);
    expect(result).toBe(0);
  });
});
```

#### 5.3.2 复活机制

**测试场景**: 验证断签保护（复活机制）

```javascript
describe('Streak System - Resurrection', () => {
  test('断签 1 天，使用复活后连击继续', () => {
    const history = generateStreakWithGap(7, 1);
    const resurrectionsUsed = 0;

    const result = applyResurrection(history, resurrectionsUsed);
    expect(result.streak).toBe(8);
    expect(result.resurrectionsUsed).toBe(1);
  });

  test('当月复活次数已达上限，断签后连击中断', () => {
    const history = generateStreakWithGap(7, 1);
    const resurrectionsUsed = 3; // 已使用 3 次

    const result = applyResurrection(history, resurrectionsUsed);
    expect(result.streak).toBe(0);
    expect(result.resurrectionsUsed).toBe(3);
  });

  test('断签 2 天，复活只能保护 1 天', () => {
    const history = generateStreakWithGap(7, 2);
    const resurrectionsUsed = 0;

    const result = applyResurrection(history, resurrectionsUsed);
    expect(result.streak).toBe(0);
  });
});
```

### 5.4 属性系统测试

#### 5.4.1 属性计算

**测试场景**: 验证四象限对应属性的增长

```javascript
describe('Attribute System', () => {
  test('完成第一象限任务，力量属性增加', () => {
    const attributes = { strength: 10, wisdom: 8, agility: 5, charisma: 3 };
    const result = updateAttribute(attributes, 1, 1); // quadrant 1, difficulty 1

    expect(result.strength).toBeGreaterThan(10);
    expect(result.wisdom).toBe(8);
    expect(result.agility).toBe(5);
    expect(result.charisma).toBe(3);
  });

  test('属性增长与任务难度成正比', () => {
    const attributes = { strength: 10, wisdom: 8, agility: 5, charisma: 3 };

    const result1 = updateAttribute(attributes, 1, 1);
    const result5 = updateAttribute(attributes, 1, 5);

    const growth1 = result1.strength - 10;
    const growth5 = result5.strength - 10;

    expect(growth5).toBeGreaterThan(growth1);
  });
});
```

#### 5.4.2 属性平衡检测

**测试场景**: 验证属性失衡时的友好提示

```javascript
describe('Attribute Balance', () => {
  test('力量远高于智慧，触发"莽夫"提示', () => {
    const attributes = { strength: 20, wisdom: 5, agility: 10, charisma: 8 };
    const result = checkAttributeBalance(attributes);

    expect(result.isBalanced).toBe(false);
    expect(result.warning).toContain('规划长期目标');
  });

  test('四项均衡，触发隐藏成就', () => {
    const attributes = { strength: 12, wisdom: 11, agility: 13, charisma: 12 };
    const result = checkAttributeBalance(attributes);

    expect(result.isBalanced).toBe(true);
    expect(result.achievement).toBe('四象限大师');
  });
});
```

### 5.5 成就系统测试

#### 5.5.1 成就解锁逻辑

**测试场景**: 验证成就解锁条件判断

```javascript
describe('Achievement System', () => {
  test('首次完成任务，解锁"初出茅庐"成就', () => {
    const userStats = { tasksCompleted: 1 };
    const result = checkAchievements(userStats);

    expect(result).toContainEqual(
      expect.objectContaining({ id: 'first_task', name: '初出茅庐' })
    );
  });

  test('连击 7 天，解锁"一周坚持"成就', () => {
    const userStats = { streak: 7 };
    const result = checkAchievements(userStats);

    expect(result).toContainEqual(
      expect.objectContaining({ id: 'streak_7', name: '一周坚持' })
    );
  });

  test('隐藏成就不显示条件', () => {
    const achievement = getAchievementById('hidden_001');

    expect(achievement.isHidden).toBe(true);
    expect(achievement.condition).toBeUndefined(); // 不显示条件
  });

  test('传奇成就触发概率极低', () => {
    const result = checkLegendaryAchievements(mockUserData);

    expect(result.length).toBeLessThanOrEqual(1);
  });
});
```

---

## 6. AI 任务拆分测试

### 6.1 拆分准确性测试

**测试场景**: 验证 AI 生成的子任务列表合理性

```javascript
describe('AI Task Decomposition', () => {
  test('长任务拆分为合理数量的子任务', async () => {
    const longTask = {
      title: '准备托福考试',
      duration: 90, // 天
      dailyTime: 2 // 小时
    };

    const result = await decomposeTask(longTask);

    expect(result.subtasks.length).toBeGreaterThan(5);
    expect(result.subtasks.length).toBeLessThan(50);
  });

  test('子任务有明确的截止日期', async () => {
    const longTask = {
      title: '学习 Python',
      duration: 60,
      dailyTime: 1
    };

    const result = await decomposeTask(longTask);

    result.subtasks.forEach((subtask, index) => {
      expect(subtask.deadline).toBeDefined();
      if (index > 0) {
        expect(subtask.deadline).toBeAfter(result.subtasks[index - 1].deadline);
      }
    });
  });

  test('拆分逻辑透明可解释', async () => {
    const longTask = {
      title: '开发个人网站',
      duration: 30,
      dailyTime: 3
    };

    const result = await decomposeTask(longTask);

    expect(result.explanation).toBeDefined();
    expect(result.explanation.dependencies).toBeDefined();
    expect(result.explanation.difficultyCurve).toBeDefined();
  });
});
```

### 6.2 拆分性能测试

**测试场景**: 验证 AI 拆分响应时间

```javascript
describe('AI Task Decomposition - Performance', () => {
  test('拆分请求在 5 秒内完成', async () => {
    const longTask = {
      title: '准备研究生考试',
      duration: 180,
      dailyTime: 4
    };

    const startTime = Date.now();
    await decomposeTask(longTask);
    const endTime = Date.now();

    expect(endTime - startTime).toBeLessThan(5000);
  });
});
```

### 6.3 动态重规划测试

**测试场景**: 验证进度偏离时的重规划逻辑

```javascript
describe('Dynamic Replanning', () => {
  test('连续 3 天未完成，触发重规划建议', async () => {
    const progress = {
      completedDays: 0,
      totalDays: 3,
      reason: '工作忙'
    };

    const result = await suggestReplanning(progress);

    expect(result.options).toHaveLength(3);
    expect(result.options[0]).toHaveProperty('description');
    expect(result.options[0]).toHaveProperty('impact');
  });

  test('用户选择保留编辑权', async () => {
    const replanOptions = await suggestReplanning(mockProgress);
    const userChoice = replanOptions[0];

    const result = await applyReplanning(userChoice, mockOriginalPlan);

    expect(result.canEdit).toBe(true);
    expect(result.userHasFinalSay).toBe(true);
  });
});
```

---

## 7. 数据分析测试

### 7.1 数据采集测试

**测试场景**: 验证行为日志采集的准确性

```javascript
describe('Data Collection', () => {
  test('任务创建事件正确记录', async () => {
    const task = await createTask({
      title: '测试任务',
      quadrant: 2,
      difficulty: 3
    });

    const logs = await getBehaviorLogs(userId, 'task_created');

    expect(logs).toContainEqual(
      expect.objectContaining({
        event_type: 'task_created',
        task_id: task.id,
        quadrant: 2,
        difficulty: 3
      })
    );
  });

  test('任务完成事件包含实际时长', async () => {
    const task = await createTask({ estimatedDuration: 60 });
    await completeTask(task.id, { actualDuration: 45 });

    const logs = await getBehaviorLogs(userId, 'task_completed');

    expect(logs[0]).toHaveProperty('actual_duration', 45);
    expect(logs[0]).toHaveProperty('estimated_duration', 60);
  });

  test('时间戳精确到秒', async () => {
    await createTask({ title: '时间测试' });

    const logs = await getBehaviorLogs(userId);

    expect(logs[0].event_timestamp).toMatch(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/);
  });
});
```

### 7.2 每日简报测试

**测试场景**: 验证每日简报生成的准确性

```javascript
describe('Daily Briefing', () => {
  test('昨日任务统计准确', async () => {
    // 准备测试数据：昨日创建 10 个任务，完成 8 个
    await createTestTasks(userId, 10, 'yesterday');
    await completeTestTasks(userId, 8, 'yesterday');

    const briefing = await generateDailyBriefing(userId);

    expect(briefing.yesterdayReview.tasksCreated).toBe(10);
    expect(briefing.yesterdayReview.tasksCompleted).toBe(8);
  });

  test('四象限分布计算正确', async () => {
    await createTestTasksInQuadrants(userId, {
      q1: 2, q2: 5, q3: 1, q4: 0
    });

    const briefing = await generateDailyBriefing(userId);

    expect(briefing.yesterdayReview.quadrantDistribution).toEqual([2, 5, 1, 0]);
  });

  test('关键发现生成合理', async () => {
    // 准备数据：上午完成 5 个第一象限任务
    await createTestTasksWithTime(userId, [
      { quadrant: 1, completedAt: '09:00' },
      { quadrant: 1, completedAt: '10:00' },
      // ... 共 5 个
    ]);

    const briefing = await generateDailyBriefing(userId);

    expect(briefing.keyInsights).toContainEqual(
      expect.stringContaining('第一象限')
    );
  });

  test('今日建议可操作', async () => {
    const briefing = await generateDailyBriefing(userId);

    expect(briefing.todaySuggestions.length).toBeGreaterThan(0);
    expect(briefing.todaySuggestions.length).toBeLessThanOrEqual(3);

    briefing.todaySuggestions.forEach(suggestion => {
      expect(suggestion).toMatch(/^(尝试|安排|完成)/);
    });
  });
});
```

### 7.3 周度报告测试

**测试场景**: 验证周度报告的准确性

```javascript
describe('Weekly Report', () => {
  test('核心指标计算准确', async () => {
    // 准备 1 周的测试数据
    await createWeeklyTestData(userId, {
      created: 70,
      completed: 56,
      onTime: 48,
      delayed: 8
    });

    const report = await generateWeeklyReport(userId);

    expect(report.metrics.completionRate).toBeCloseTo(80, 1); // 56/70
    expect(report.metrics.onTimeRate).toBeCloseTo(85.7, 1); // 48/56
  });

  test('四象限健康度计算正确', async () => {
    await createQuadrantTestData(userId, {
      q1: 0.22, q2: 0.48, q3: 0.20, q4: 0.10 // 接近理想分布
    });

    const report = await generateWeeklyReport(userId);

    expect(report.metrics.quadrantHealthScore).toBeGreaterThan(70);
    expect(report.metrics.quadrantHealthScore).toBeLessThanOrEqual(100);
  });

  test('最佳时刻识别准确', async () => {
    // 准备数据：周三上午完成率最高
    await createPerformanceData(userId, {
      '周三上午': { completionRate: 95 },
      '其他时段': { completionRate: 70 }
    });

    const report = await generateWeeklyReport(userId);

    expect(report.bestMoments).toContainEqual(
      expect.stringContaining('周三上午')
    );
  });

  test('改进建议可操作', async () => {
    const report = await generateWeeklyReport(userId);

    expect(report.improvementOpportunities).toBeDefined();
    expect(report.nextWeekExperiments).toBeDefined();
    expect(report.nextWeekExperiments.length).toBeGreaterThan(0);
  });
});
```

### 7.4 洞察引擎测试

**测试场景**: 验证洞察生成的准确性

```javascript
describe('Insight Engine', () => {
  test('高优先级洞察：Burnout 风险检测', async () => {
    // 准备数据：连续 2 周工作超 60 小时
    await createOverworkData(userId, 14);

    const insights = await generateInsights(userId);

    expect(insights).toContainEqual(
      expect.objectContaining({
        priority: 1, // 高优先级
        type: 'burnout_risk'
      })
    );
  });

  test('中优先级洞察：象限持续偏低', async () => {
    // 准备数据：第二象限 7 天未添加任务
    await createQuadrantGapData(userId, 2, 7);

    const insights = await generateInsights(userId);

    expect(insights).toContainEqual(
      expect.objectContaining({
        priority: 2, // 中优先级
        type: 'quadrant_imbalance'
      })
    );
  });

  test('每个洞察配可操作建议', async () => {
    const insights = await generateInsights(userId);

    insights.forEach(insight => {
      expect(insight.actionableSuggestion).toBeDefined();
      expect(insight.actionableSuggestion.split('\n').length).toBeLessThanOrEqual(3);
    });
  });

  test('支持反思记录', async () => {
    const insight = await createInsight(userId, {
      title: '测试洞察',
      description: '测试描述'
    });

    await addReflection(insight.id, '这符合我的感受');

    const updated = await getInsight(insight.id);
    expect(updated.reflection).toBe('这符合我的感受');
  });
});
```

---

## 8. 性能测试

### 8.1 页面加载性能

**测试场景**: 验证首屏加载时间 < 2 秒

```javascript
describe('Page Load Performance', () => {
  test('首页加载时间 < 2 秒', async () => {
    const { metrics } = await lighthouse.run('http://localhost:3000');

    expect(metrics.firstContentfulPaint).toBeLessThan(2000);
    expect(metrics.speedIndex).toBeLessThan(3000);
  });

  test('任务列表页加载时间 < 2 秒', async () => {
    // 模拟 100 个任务
    await createTasks(userId, 100);

    const startTime = Date.now();
    await page.goto('http://localhost:3000/tasks');
    await page.waitForSelector('[data-testid="task-list"]');
    const endTime = Date.now();

    expect(endTime - startTime).toBeLessThan(2000);
  });
});
```

### 8.2 API 响应性能

**测试场景**: 验证 API 响应时间 < 500ms

```javascript
describe('API Response Time', () => {
  test('任务创建接口 < 500ms', async () => {
    const startTime = Date.now();
    await request(app)
      .post('/api/tasks')
      .send({ title: '测试任务', quadrant: 2, difficulty: 3 });
    const endTime = Date.now();

    expect(endTime - startTime).toBeLessThan(500);
  });

  test('任务列表查询 < 500ms（100 个任务）', async () => {
    await createTasks(userId, 100);

    const startTime = Date.now();
    await request(app)
      .get('/api/tasks')
      .query({ userId });
    const endTime = Date.now();

    expect(endTime - startTime).toBeLessThan(500);
  });

  test('数据报告生成 < 5 秒', async () => {
    // 准备 1 周的数据
    await createWeeklyData(userId);

    const startTime = Date.now();
    await request(app)
      .get('/api/reports/weekly')
      .query({ userId });
    const endTime = Date.now();

    expect(endTime - startTime).toBeLessThan(5000);
  });
});
```

### 8.3 并发性能测试

**测试场景**: 验证系统支持 100 并发用户

```javascript
describe('Concurrent Performance', () => {
  test('100 用户并发创建任务', async () => {
    const users = await createTestUsers(100);

    const startTime = Date.now();
    const promises = users.map(user =>
      request(app)
        .post('/api/tasks')
        .set('Authorization', `Bearer ${user.token}`)
        .send({ title: '并发测试任务', quadrant: 1, difficulty: 2 })
    );

    const results = await Promise.all(promises);
    const endTime = Date.now();

    const successCount = results.filter(r => r.status === 200).length;
    expect(successCount).toBe(100);
    expect(endTime - startTime).toBeLessThan(5000); // 总时间 < 5 秒
  });
});
```

### 8.4 大数据量测试

**测试场景**: 验证大数据量下的性能

```javascript
describe('Large Data Volume', () => {
  test('10,000 条行为日志查询 < 3 秒', async () => {
    await createBehaviorLogs(userId, 10000);

    const startTime = Date.now();
    await request(app)
      .get('/api/analytics/logs')
      .query({ userId, limit: 100 });
    const endTime = Date.now();

    expect(endTime - startTime).toBeLessThan(3000);
  });

  test('月度报告生成（6 个月数据）< 10 秒', async () => {
    await createMonthlyData(userId, 6);

    const startTime = Date.now();
    await request(app)
      .get('/api/reports/monthly')
      .query({ userId });
    const endTime = Date.now();

    expect(endTime - startTime).toBeLessThan(10000);
  });
});
```

---

## 9. 离线与同步测试

### 9.1 离线功能测试

**测试场景**: 验证核心功能离线可用

```javascript
describe('Offline Functionality', () => {
  test('离线创建任务', async () => {
    await page.goto('http://localhost:3000');

    // 断开网络
    await page.context().setOffline(true);

    // 创建任务
    await page.click('[data-testid="create-task"]');
    await page.fill('[data-testid="task-title"]', '离线任务');
    await page.click('[data-testid="submit-task"]');

    // 验证任务已保存到本地
    const tasks = await page.evaluate(() => {
      return JSON.parse(localStorage.getItem('offline_tasks'));
    });

    expect(tasks).toContainEqual(
      expect.objectContaining({ title: '离线任务' })
    );
  });

  test('离线完成任务', async () => {
    await createTask(userId, { title: '待完成任务' });
    await page.goto('http://localhost:3000/tasks');

    await page.context().setOffline(true);
    await page.click('[data-testid="complete-task"]');

    // 验证本地状态更新
    const taskStatus = await page.textContent('[data-testid="task-status"]');
    expect(taskStatus).toBe('completed');
  });
});
```

### 9.2 数据同步测试

**测试场景**: 验证网络恢复后数据同步

```javascript
describe('Data Synchronization', () => {
  test('离线任务在网络恢复后同步', async () => {
    // 离线创建 3 个任务
    await page.context().setOffline(true);
    await createTasksViaUI(['任务1', '任务2', '任务3']);

    // 恢复网络
    await page.context().setOffline(false);

    // 等待同步完成
    await page.waitForSelector('[data-testid="sync-complete"]');

    // 验证服务端数据
    const serverTasks = await getTasksFromServer(userId);
    expect(serverTasks).toHaveLength(3);
  });

  test('冲突解决：服务端优先', async () => {
    // 服务端已有任务（标题：旧标题）
    const task = await createTaskOnServer(userId, { title: '旧标题' });

    // 离线修改任务（标题：新标题）
    await page.context().setOffline(true);
    await updateTaskViaUI(task.id, { title: '新标题' });

    // 服务端同时修改（标题：服务端标题）
    await updateTaskOnServer(task.id, { title: '服务端标题' });

    // 恢复网络，触发同步
    await page.context().setOffline(false);
    await page.waitForSelector('[data-testid="sync-complete"]');

    // 验证冲突解决（服务端优先）
    const finalTask = await getTask(task.id);
    expect(finalTask.title).toBe('服务端标题');
  });

  test('同步失败重试机制', async () => {
    await page.context().setOffline(true);
    await createTasksViaUI(['测试任务']);

    // 模拟同步失败
    await mockSyncFailure();
    await page.context().setOffline(false);

    // 等待自动重试
    await page.waitForTimeout(5000);

    // 验证重试成功
    const syncStatus = await page.textContent('[data-testid="sync-status"]');
    expect(syncStatus).toBe('synced');
  });
});
```

---

## 10. 兼容性测试

### 10.1 浏览器兼容性

**测试场景**: 验证主流浏览器兼容性

| 浏览器 | 版本 | 测试内容 |
|--------|------|----------|
| Chrome | 最新 2 个版本 | 全功能测试 |
| Firefox | 最新 2 个版本 | 全功能测试 |
| Safari | 最新 2 个版本 | 全功能测试 |
| Edge | 最新 2 个版本 | 全功能测试 |

```javascript
describe('Browser Compatibility', () => {
  const browsers = ['chromium', 'firefox', 'webkit'];

  browsers.forEach(browserType => {
    test(`${browserType} - 任务创建功能`, async () => {
      const browser = await playwright[browserType].launch();
      const page = await browser.newPage();

      await page.goto('http://localhost:3000');
      await createTaskViaUI(page, { title: '兼容性测试' });

      const taskTitle = await page.textContent('[data-testid="task-title"]');
      expect(taskTitle).toBe('兼容性测试');

      await browser.close();
    });
  });
});
```

### 10.2 移动端适配

**测试场景**: 验证移动端界面适配

```javascript
describe('Mobile Responsiveness', () => {
  const devices = [
    { name: 'iPhone 12', width: 390, height: 844 },
    { name: 'iPhone SE', width: 375, height: 667 },
    { name: 'Pixel 5', width: 393, height: 851 },
    { name: 'iPad', width: 768, height: 1024 }
  ];

  devices.forEach(device => {
    test(`${device.name} - 界面适配`, async () => {
      await page.setViewportSize({ width: device.width, height: device.height });
      await page.goto('http://localhost:3000');

      // 验证关键元素可见
      const taskList = await page.isVisible('[data-testid="task-list"]');
      const createButton = await page.isVisible('[data-testid="create-task"]');

      expect(taskList).toBe(true);
      expect(createButton).toBe(true);
    });
  });
});
```

---

## 11. 安全测试

### 11.1 数据安全测试

**测试场景**: 验证用户数据安全

```javascript
describe('Data Security', () => {
  test('用户只能访问自己的任务', async () => {
    const user1Task = await createTask(user1.id, { title: '用户1的任务' });

    const response = await request(app)
      .get(`/api/tasks/${user1Task.id}`)
      .set('Authorization', `Bearer ${user2.token}`);

    expect(response.status).toBe(403);
  });

  test('敏感数据加密存储', async () => {
    const user = await createUser({ password: 'plaintext123' });

    const dbUser = await getUserFromDB(user.id);
    expect(dbUser.password).not.toBe('plaintext123');
    expect(dbUser.password).toMatch(/^\$2[aby]\$/); // bcrypt hash
  });

  test('数据导出功能正确', async () => {
    await createTasks(userId, 10);

    const response = await request(app)
      .get('/api/users/export')
      .set('Authorization', `Bearer ${user.token}`);

    expect(response.status).toBe(200);
    expect(response.headers['content-type']).toBe('application/json');

    const data = JSON.parse(response.text);
    expect(data.tasks).toBeDefined();
    expect(data.tasks.length).toBe(10);
  });

  test('账号删除后数据清除', async () => {
    await createTasks(userId, 5);

    await request(app)
      .delete('/api/users/account')
      .set('Authorization', `Bearer ${user.token}`);

    const tasks = await getTasksFromDB(userId);
    expect(tasks.length).toBe(0);
  });
});
```

### 11.2 输入验证测试

**测试场景**: 验证输入数据的合法性

```javascript
describe('Input Validation', () => {
  test('任务标题 XSS 攻击防护', async () => {
    const maliciousTitle = '<script>alert("XSS")</script>';

    const response = await request(app)
      .post('/api/tasks')
      .send({ title: maliciousTitle, quadrant: 1, difficulty: 1 });

    expect(response.status).toBe(201);
    expect(response.body.title).not.toContain('<script>');
  });

  test('SQL 注入防护', async () => {
    const maliciousId = "1'; DROP TABLE tasks; --";

    const response = await request(app)
      .get(`/api/tasks/${maliciousId}`)
      .set('Authorization', `Bearer ${user.token}`);

    expect(response.status).toBe(400);

    // 验证数据库未被破坏
    const tasks = await getAllTasks();
    expect(tasks.length).toBeGreaterThan(0);
  });

  test('难度范围验证', async () => {
    const response = await request(app)
      .post('/api/tasks')
      .send({ title: '测试', quadrant: 1, difficulty: 10 }); // 超出范围

    expect(response.status).toBe(400);
    expect(response.body.error).toContain('difficulty');
  });
});
```

---

## 12. UAT 测试方案

### 12.1 UAT 测试目标

验证系统满足用户核心诉求：
1. 能帮助用户真正完成任务
2. 不增加用户负担
3. 能理解用户特殊情况

### 12.2 UAT 测试用户

**招募标准**:
- 年龄 25-35 岁
- 使用过至少 1 款待办应用
- 有自我提升意愿但难以坚持
- 每周可投入 30 分钟测试时间

**用户数量**: 20 人

**分组**:
- A 组（10 人）：游戏模式用户
- B 组（10 人）：专业模式用户

### 12.3 UAT 测试场景

#### 场景 1：新用户 Onboarding

**测试步骤**:
1. 打开应用，完成注册
2. 设置"为什么来这里"目标
3. 选择模式（游戏/专业）
4. 了解四象限分类方法
5. 创建第一个任务

**验收标准**:
- ✅ 整个流程 < 5 分钟
- ✅ 用户无困惑感
- ✅ 成功创建第一个任务

#### 场景 2：日常任务管理

**测试步骤**:
1. 每天创建 3-5 个任务
2. 使用四象限分类
3. 完成任务
4. 查看每日简报
5. 记录主观感受（可选）

**验收标准**:
- ✅ 每日记录时间 < 5 分钟
- ✅ 任务完成率 > 60%
- ✅ 用户不感到负担

#### 场景 3：长任务与 AI 拆分

**测试步骤**:
1. 创建一个长任务（如"准备考试"）
2. 使用 AI 拆分功能
3. 查看生成的学习路径
4. 编辑和调整计划
5. 开始执行

**验收标准**:
- ✅ AI 拆分在 5 秒内完成
- ✅ 用户认为拆分合理（满意度 ≥ 4/5）
- ✅ 用户知道如何编辑计划

#### 场景 4：断签与复活

**测试步骤**:
1. 连续使用应用 7 天
2. 第 8 天不使用（模拟断签）
3. 第 9 天返回应用
4. 查看文案提示
5. 使用复活功能

**验收标准**:
- ✅ 文案积极友好（"欢迎回来"）
- ✅ 用户理解复活机制
- ✅ 用户有动力继续使用

#### 场景 5：数据洞察

**测试步骤**:
1. 使用应用 1 周
2. 查看周度报告
3. 阅读洞察建议
4. 记录反思（可选）
5. 调整行为

**验收标准**:
- ✅ 用户认为洞察有价值（满意度 ≥ 4/5）
- ✅ 用户愿意根据建议调整
- ✅ 用户不感到焦虑

### 12.4 UAT 测试指标

| 指标 | 目标值 | 测量方式 |
|------|--------|----------|
| 任务完成率 | > 60% | 系统统计 |
| 日常使用负担 | < 5 分钟/天 | 用户反馈 |
| Onboarding 满意度 | ≥ 4/5 | 问卷调查 |
| 文案友好度 | ≥ 4/5 | 问卷调查 |
| AI 拆分满意度 | ≥ 4/5 | 问卷调查 |
| 数据洞察价值 | ≥ 4/5 | 问卷调查 |
| 继续使用意愿 | > 70% | 问卷调查 |
| NPS | > 30 | NPS 调研 |

### 12.5 UAT 测试流程

```
第 1 天：Onboarding + 面对面访谈（30 分钟）
  ↓
第 2-7 天：自主使用，每天记录感受
  ↓
第 8 天：断签测试（不使用应用）
  ↓
第 9 天：复活测试 + 访谈（15 分钟）
  ↓
第 10-14 天：继续使用
  ↓
第 14 天：总结访谈 + 问卷调查（30 分钟）
```

### 12.6 UAT 测试报告模板

```markdown
# UAT 测试报告

## 测试概况
- 测试时间：YYYY-MM-DD ~ YYYY-MM-DD
- 参与用户：20 人（游戏模式 10 人，专业模式 10 人）
- 测试场景：5 个核心场景

## 关键发现

### 正面反馈
1. ...
2. ...

### 负面反馈
1. ...
2. ...

### 惊喜发现
1. ...

## 定量指标
| 指标 | 目标值 | 实际值 | 达标 |
|------|--------|--------|------|
| 任务完成率 | > 60% | XX% | ✅/❌ |
| Onboarding 满意度 | ≥ 4/5 | X.X | ✅/❌ |
| ... | ... | ... | ... |

## 问题优先级

### P0 - 必须修复
1. ...
2. ...

### P1 - 应该修复
1. ...

### P2 - 建议修复
1. ...

## 用户建议
1. ...
2. ...

## 下一步行动
1. ...
2. ...
```

---

## 13. 测试环境与工具

### 13.1 测试环境

| 环境 | 用途 | 配置 |
|------|------|------|
| 开发环境 | 开发自测 | 本地 Docker |
| 测试环境 | 自动化测试 | CI/CD 服务器 |
| 预发布环境 | UAT 测试 | 云服务器（类生产） |
| 生产环境 | 真实用户 | 云服务器（高可用） |

### 13.2 测试工具

#### 单元测试
- **前端**: Jest + React Testing Library
- **后端**: Pytest + pytest-cov

#### 集成测试
- **API 测试**: Supertest (Node.js) / Pytest + Requests (Python)
- **数据库测试**: TestContainers (Docker)

#### E2E 测试
- **Web**: Playwright / Cypress
- **移动端**: Appium (可选)

#### 性能测试
- **负载测试**: Artillery / k6
- **前端性能**: Lighthouse
- **API 性能**: Apache Bench / wrk

#### 兼容性测试
- **浏览器**: BrowserStack / Sauce Labs
- **移动端**: Chrome DevTools Device Mode

#### 安全测试
- **静态分析**: SonarQube
- **依赖扫描**: npm audit / safety (Python)
- **渗透测试**: OWASP ZAP

### 13.3 CI/CD 集成

```yaml
# .github/workflows/test.yml
name: Test Pipeline

on: [push, pull_request]

jobs:
  unit-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run unit tests
        run: |
          npm install
          npm run test:unit -- --coverage
      - name: Upload coverage
        uses: codecov/codecov-action@v2

  integration-test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:13
        env:
          POSTGRES_PASSWORD: test
      redis:
        image: redis:6
    steps:
      - uses: actions/checkout@v2
      - name: Run integration tests
        run: |
          npm install
          npm run test:integration

  e2e-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run E2E tests
        run: |
          npm install
          npm run test:e2e
      - name: Upload test results
        uses: actions/upload-artifact@v2
        with:
          name: playwright-report
          path: playwright-report/

  performance-test:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v2
      - name: Run performance tests
        run: |
          npm install -g artillery
          artillery run tests/performance/api-load.yml
```

---

## 14. 风险与缓解措施

### 14.1 测试风险

| 风险 | 可能性 | 影响 | 缓解措施 |
|------|--------|------|----------|
| 自动化测试不稳定 | 高 | 中 | 增加重试机制，优化等待策略 |
| 测试数据准备耗时 | 中 | 中 | 使用数据工厂模式，预生成测试数据 |
| UAT 用户流失 | 中 | 高 | 提供激励，简化测试流程 |
| 性能测试环境差异 | 中 | 中 | 使用容器化测试环境 |
| AI 测试结果不可控 | 高 | 中 | Mock AI 服务，定义预期输出范围 |
| 离线测试复杂度高 | 中 | 低 | 使用 Service Worker 模拟，逐步测试 |

### 14.2 质量风险

| 风险 | 可能性 | 影响 | 缓解措施 |
|------|--------|------|----------|
| 游戏化逻辑计算错误 | 中 | 高 | 100% 单元测试覆盖，边界值测试 |
| 数据分析不准确 | 中 | 高 | 使用真实数据验证，人工审核 |
| AI 拆分结果不合理 | 高 | 中 | 用户可编辑，收集反馈持续优化 |
| 离线同步冲突 | 中 | 中 | 明确冲突解决策略，用户提示 |
| 性能退化 | 低 | 中 | 持续性能监控，自动化性能测试 |

### 14.3 缓解措施执行计划

| 措施 | 负责人 | 时间节点 | 验收标准 |
|------|--------|----------|----------|
| 优化自动化测试稳定性 | 测试工程师 | P0 结束 | Flaky 测试率 < 5% |
| 建立测试数据工厂 | 后端工程师 | P0 W2 | 数据生成时间 < 10 秒 |
| 制定 UAT 激励方案 | 产品经理 | P0 W1 | 用户留存率 > 80% |
| 配置性能监控 | DevOps | P0 W3 | 实时性能报告可用 |

---

## 附录

### A. 测试用例清单

**P0 阶段测试用例数量**:
- 单元测试：200+
- 集成测试：50+
- E2E 测试：20+
- 性能测试：10+
- 兼容性测试：50+

**总计**: 330+ 测试用例

### B. 测试数据模板

```javascript
// 测试用户数据
const testUser = {
  id: 'test-user-001',
  email: 'test@example.com',
  password: 'Test123!@#',
  mode: 'game', // or 'professional'
  level: 5,
  xp: 500,
  streak: 7
};

// 测试任务数据
const testTask = {
  id: 'test-task-001',
  title: '测试任务',
  quadrant: 2,
  difficulty: 3,
  estimatedDuration: 60,
  status: 'pending'
};
```

### C. 参考文档

- 需求文档: `/docs/requirements/requirements_document.md`
- 设计方案: `/docs/design/plan_start_01.md`
- 测试最佳实践: [链接]
- Playwright 文档: [链接]
- Jest 文档: [链接]

---

**文档结束**

> 本测试策略文档将根据项目进展持续更新，确保测试覆盖所有核心功能和风险点。