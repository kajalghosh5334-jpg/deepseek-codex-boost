#!/bin/bash
set -e

# DeepSeek Codex Boost — 一键安装脚本
# 将增强文件部署到 ~/.codex/，自动备份已有文件

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$CODEX_HOME/backup_$(date +%Y%m%d_%H%M%S)"

echo "╔══════════════════════════════════════════╗"
echo "║   DeepSeek Codex Boost 安装脚本          ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Codex Home: $CODEX_HOME"
echo "备份目录:   $BACKUP_DIR"
echo ""

# 确认
read -p "是否继续安装？(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "已取消。"
    exit 0
fi

mkdir -p "$BACKUP_DIR"
mkdir -p "$CODEX_HOME/deepseek-prompt/skills"
mkdir -p "$CODEX_HOME/templates/agent_memory"
mkdir -p "$CODEX_HOME/skills"

# 备份函数
backup_and_copy() {
    local src="$1"
    local dst="$2"
    if [ -f "$dst" ] || [ -d "$dst" ]; then
        cp -r "$dst" "$BACKUP_DIR/$(basename "$dst")" 2>/dev/null || true
        echo "  📦 已备份: $(basename "$dst")"
    fi
    if [ -d "$src" ]; then
        cp -r "$src/"* "$dst/" 2>/dev/null || true
    else
        cp "$src" "$dst"
    fi
    echo "  ✅ 已安装: $(basename "$dst")"
}

echo "━━━ 安装核心配置 ━━━"
echo ""

# 1. AGENTS.md（核心用户级配置）
backup_and_copy "$SCRIPT_DIR/AGENTS.md" "$CODEX_HOME/AGENTS.md"

# 2. deepseek-prompt
echo ""
echo "━━━ 安装 DeepSeek Prompt 系统 ━━━"
echo ""
backup_and_copy "$SCRIPT_DIR/deepseek-prompt/system_prompt.md" "$CODEX_HOME/deepseek-prompt/system_prompt.md"
backup_and_copy "$SCRIPT_DIR/deepseek-prompt/role_vectors.json" "$CODEX_HOME/deepseek-prompt/role_vectors.json"
backup_and_copy "$SCRIPT_DIR/deepseek-prompt/skills/role_updater.md" "$CODEX_HOME/deepseek-prompt/skills/role_updater.md"

# 3. skill_index.md
echo ""
echo "━━━ 安装 Skill 索引 ━━━"
echo ""
backup_and_copy "$SCRIPT_DIR/skill_index.md" "$CODEX_HOME/skill_index.md"

# 4. agent_memory 模板
echo ""
echo "━━━ 安装 Agent Memory 模板 ━━━"
echo ""
for tmpl in context.md progress.md bugs.md; do
    backup_and_copy "$SCRIPT_DIR/templates/agent_memory/$tmpl" "$CODEX_HOME/templates/agent_memory/$tmpl"
done

# 5. DeepSeek 专用 skills
echo ""
echo "━━━ 安装 DeepSeek 专用 Skills ━━━"
echo ""
for skill_dir in "$SCRIPT_DIR"/skills/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -f "$skill_dir/SKILL.md" ]; then
        mkdir -p "$CODEX_HOME/skills/$skill_name"
        backup_and_copy "$skill_dir/SKILL.md" "$CODEX_HOME/skills/$skill_name/SKILL.md"
    fi
done

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   ✅ 安装完成！                          ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "备份文件保存在: $BACKUP_DIR"
echo ""
echo "下一步："
echo "  1. 确保 config.toml 中 model = \"deepseek-v4-pro\"（或其他 DeepSeek 模型）"
echo "  2. 重启 Codex CLI 或新建会话使配置生效"
echo "  3. 在新项目中，agent_memory 模板会自动创建"
echo ""
echo "如需回滚："
echo "  cp -r $BACKUP_DIR/* $CODEX_HOME/"
echo ""
