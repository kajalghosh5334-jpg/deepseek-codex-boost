# DeepSeek Codex Boost

> 让 DeepSeek 在 Codex CLI 中接近 Claude 80% 的工程能力

## 这是什么？

这是一套为 **DeepSeek 模型 + Codex CLI** 量身定做的提示词工程（Prompt Engineering）增强包。通过多层架构设计，补足 DeepSeek 在以下方面的短板：

- **全局思维**：意图识别 → 角色激活 → 场景还原 → 约束提取，四步自检链
- **任务聚焦**：角色向量表驱动本能关注点，防止输出发散
- **输出质量**：三层递进模板（L1 总览 → L2 详情 → L3 决策说明）
- **项目记忆**：agent_memory 模板（context / progress / bugs），跨会话保持上下文
- **多代理协作**：Plan → Design → Build → QA → Ship 五节点流水线
- **安全约束**：freeze / guard / careful 三层防御

## 目录结构

```
deepseek-codex-boost/
├── AGENTS.md                          # 用户级配置（核心入口）
├── deepseek-prompt/
│   ├── system_prompt.md               # DeepSeek 专用 system prompt
│   ├── role_vectors.json              # 10 个角色向量完整数据
│   └── skills/
│       └── role_updater.md            # 角色扩展工具
├── skill_index.md                     # 78 个 skill 索引匹配表
├── templates/
│   └── agent_memory/
│       ├── context.md                 # 项目上下文模板
│       ├── progress.md                # 进度跟踪模板
│       └── bugs.md                    # 问题/风险记录模板
├── skills/                            # DeepSeek 专用 skill 集
│   ├── plan-agent/SKILL.md            # 架构规划节点
│   ├── design-agent/SKILL.md          # 设计规范节点
│   ├── build-agent/SKILL.md           # 代码实现节点
│   ├── qa-agent/SKILL.md              # 测试审查节点
│   ├── ship-agent/SKILL.md            # 交付文档节点
│   ├── brainstorming-plan/SKILL.md    # 创意前置规划
│   ├── karpathy-guidelines-plan/SKILL.md  # LLM 防错指南
│   ├── multi-agent/SKILL.md           # 多 agent 协作简报
│   ├── frontend-design-build/SKILL.md # 生产级前端界面
│   ├── freeze/SKILL.md                # 目录锁定
│   ├── guard/SKILL.md                 # 全防护模式
│   ├── careful/SKILL.md               # 危险命令警告
│   ├── unfreeze/SKILL.md              # 解除锁定
│   ├── using-superpowers-ops/SKILL.md # 技能使用入门
│   ├── find-skills-ops/SKILL.md       # 技能发现
│   ├── defuddle-build/SKILL.md        # 网页清洗
│   ├── render-datamodel/SKILL.md      # 智能 ERD 生成
│   └── wechat-add-script/SKILL.md     # 微信自动添加
├── install.sh                         # 一键安装脚本
└── README.md
```

## 核心设计：意图识别 → 角色激活 → 场景还原

### 模式分层

| 模式 | 触发条件 | 行为 |
|------|----------|------|
| **模式A · 轻量** | 单领域 + 随口问 | 简短回复，跳过角色激活 |
| **模式B · 标准** | 单领域 + 正式需求 | 激活角色 + 场景还原 + 三层输出 |
| **模式C · 深度** | 跨领域 + 正式需求 | 多角色协作 + 完整报告 + 关键决策暂停确认 |

### 10 个角色向量

| 角色 | 本能关注点 | 输出模板 |
|------|-----------|----------|
| 系统架构师 | 业务边界·可扩展性·数据一致性·接口契约 | technical |
| 高级产品经理 | 用户体验·业务目标·边界条件·优先级 | strategy |
| 数据库工程师 | 范式取舍·索引策略·枚举设计·命名规范 | technical |
| 业务分析师 | 业务语义·数据口径·报表可追溯·异常态 | technical |
| SaaS业务专家 | 租户隔离·权限粒度·数据安全·功能开关 | technical |
| 数据分析师 | 指标定义·口径一致·异常识别·结论可追溯 | analysis |
| 前端工程师 | 组件复用·状态管理·性能·交互反馈 | technical |
| 后端工程师 | 幂等性·错误码·性能瓶颈·事务边界 | technical |
| 资深编辑 | 受众共鸣·信息层次·简洁·情绪节奏 | strategy |
| 战略顾问 | 第一性原理·假设显化·风险识别·优先级 | strategy |

### 三层输出模板

```
Layer 1 · 总览（架构图/ERD/关系图）
    ↓
Layer 2 · 详情（逐模块展开，字段含类型、枚举值、设计说明）
    ↓
Layer 3 · 决策说明（选了什么·放弃了什么·为什么）
```

## 安装

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/deepseek-codex-boost.git
cd deepseek-codex-boost

# 一键安装
chmod +x install.sh
./install.sh
```

安装脚本会将文件部署到 `~/.codex/` 对应位置，**自动备份**已有文件。

## 前置条件

- 已安装 [Codex CLI](https://github.com/openai/codex)
- 配置 DeepSeek 为模型提供方（`config.toml` 中设置 `model = "deepseek-v4-pro"` 或类似）
- DeepSeek 通过兼容 OpenAI API 的代理运行

## 效果对比

| 维度 | 原生 DeepSeek | + Boost |
|------|:---:|:---:|
| 全局架构思维 | ⭐⭐ | ⭐⭐⭐⭐ |
| 任务聚焦度 | ⭐⭐ | ⭐⭐⭐⭐ |
| 输出完整性（不提前截断） | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| 工程决策可追溯 | ⭐ | ⭐⭐⭐⭐ |
| 跨会话上下文保持 | ⭐ | ⭐⭐⭐⭐ |
| 多 Agent 协作 | ⭐ | ⭐⭐⭐⭐ |

## 原理

DeepSeek 模型的推理能力强，但在 Codex CLI 环境中的**行为遵循度**不如 Claude。这套 prompt 的核心思路是：

1. **结构化自检链**：通过 AGENTS.md 强制模型在输出前完成 5 步自检
2. **角色驱动输出**：用角色向量的"本能关注点"约束注意力范围
3. **分层渐进**：L1/L2/L3 机制防止跳步和截断
4. **项目记忆**：agent_memory 模板保持跨会话上下文

适合 DeepSeek v4-pro 及类似高推理能力但遵循度偏弱的模型。

## License

MIT
