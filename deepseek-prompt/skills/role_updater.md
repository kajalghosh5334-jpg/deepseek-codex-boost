# Skill: role_updater
# 能力描述：新增或扩展角色库

## 触发条件
用户说以下任意一种：
- 「新增角色」/「扩展角色库」/「我有个新场景」
- 「加一个XXX角色」/「现有角色不够用」

## 执行流程

### Step 1 · 一次性收集信息
向用户提问（不分多轮）：
- 角色名称是什么？
- 主要处理哪类任务？（几个关键词）
- 最本能关注什么？（2-4个点）
- 输出结构偏向：技术类 / 分析类 / 策略类？
- L2 展开时建议调用哪些 skill？（参考 skill_index.md）

### Step 2 · 生成角色对象
输出可直接追加到 role_vectors.json 的完整对象：

{
  "id": "snake_case_id",
  "name": "角色名称",
  "trigger_tags": ["标签1", "标签2", "标签3"],
  "instincts": ["本能1", "本能2", "本能3"],
  "output_template": "technical | analysis | strategy",
  "l2_skills": ["skill_id", "skill_id"],
  "l3_skills": ["skill_id", "skill_id"],
  "layer3_focus": [
    "决策说明示例1",
    "决策说明示例2"
  ]
}

### Step 3 · 同步更新 system_prompt.md 角色向量表
输出新增行，可直接追加到表格末尾：

| {id} | {name} | {trigger_tags} | {instincts} | {template} | {l2_skills} |

### Step 4 · 确认
输出完成后提示：
「已生成角色对象和向量表条目。
如需同时更新 AGENTS.md 附录，请手动追加上方内容。」
