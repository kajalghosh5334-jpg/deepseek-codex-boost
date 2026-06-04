---
name: multi-agent
description: Create tight, auditable task briefs for multi-agent or sub-agent work. Use when the user asks to set up multi-agent collaboration, split work across agents, create agent briefs, or coordinate sub-agents. Also use when tasks involve parallel exploration, role-based splitting, security review, verification, or handoff between agents.
---

# Multi Agent

## Overview

Use this skill to turn a user goal into a bounded agent brief. It helps structure work that benefits from role-based splitting, parallel exploration, or formal verification — without forcing unnecessary sub-agent spawning.

**核心原则：使用 skill 不等于必须启动子代理。** 是否实际委派仍遵循当前环境和上层规则。本 skill 只负责产出清晰、可审计的任务简报。

## 🔒 Router 强制流程（不可跳过）

**任何非简单任务（涉及多文件、新功能、架构变更），Router 必须按以下四阶段串行执行，禁止跳过任何阶段：**

```
用户需求
  ↓
【阶段 0】Router 分析 → 产出完整 Agent Brief（角色+目标+上下文+边界）
  ↓ 等待用户确认
【阶段 1】切 plan-agent 身份 → 先读取 plan-agent/SKILL.md → 严格使用 Allowed Skills → 产出架构/需求拆解文档
  ↓ 等待用户确认
【阶段 2】切 design-agent 身份 → 先读取 design-agent/SKILL.md → 严格使用 Allowed Skills → 产出 UI/UX 设计规范（色彩/字体/组件/布局）
  ↓ 等待用户确认
【阶段 3】切 build-agent 身份 → 先读取 build-agent/SKILL.md → 严格使用 Allowed Skills → 按 design 规范限域实现代码
  ↓
【阶段 4】切 ship-agent 身份 → 先读取 ship-agent/SKILL.md → 严格使用 Allowed Skills → 打包/文档/收尾
```

### Router 铁律
1. **拿到任务后，禁止直接写代码。** 必须先输出 Agent Brief。
2. **切换角色后，必须先 `cat` 读取对应 `~/.codex/skills/<role>/SKILL.md`，然后严格遵守其 Allowed Actions 和 Rules。**
3. **每个阶段结束后必须停止，等待用户确认再进入下一阶段。**
4. **设计规范（design）必须经用户确认后，build 才能开始。Build 必须按 design 规范实现。**

## 角色选择

| 角色 | 用途 | 典型场景 |
|------|------|----------|
| **plan-agent** | 只读探索与架构规划 | 理解现有架构、检索 API、拆解需求、定位问题 |
| **design-agent** | UI/UX 设计规范输出 | 在编码前产出色彩系统、字体、组件规范、移动端布局 |
| **build-agent** | 限域实现与代码编写 | 在指定文件范围内写代码，严格按 design 规范实现 |
| **ship-agent** | 发布部署与交接文档 | 打包构建、收尾文档、交付 zip |

## 简报模板

每个 agent brief 必须包含以下字段：

```
角色（Role）：
目标（Goal）：
上下文（Context）：
允许操作（Allowed actions）：
所有权范围（Ownership）：
禁止操作（Forbidden actions）：
输出格式（Output format）：
停止条件（Stop condition）：
```

### 字段填写指南

- **角色**：从上方角色表中选择一个
- **目标**：一句话描述要完成什么，可验证、可判断是否完成
- **上下文**：列出需要读取的文件路径、关键文档、相关历史
- **允许操作**：明确可执行的命令类型、可写的文件范围
- **所有权范围**：该代理独占的文件/目录列表
- **禁止操作**：绝对不能做的事（如不能修改某文件、不能运行某命令）
- **输出格式**：指定输出文件路径和格式（如 `agent_memory/review-report.md`）
- **停止条件**：什么时候算完成、什么情况必须停止并报告
