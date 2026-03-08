#!/bin/bash
# =============================================================================
# 禁用 Pre-commit Hook 脚本
# =============================================================================
# 功能：暂时禁用 pre-commit hook，允许提交
# =============================================================================

set -e

echo "========================================"
echo "  🔄 暂时禁用 Pre-commit Hook"
echo "========================================"

# 1. 备份当前的 pre-commit hook
if [ -f ".git/hooks/pre-commit" ]; then
    echo "📦 备份现有的 pre-commit hook..."
    mv .git/hooks/pre-commit .git/hooks/pre-commit.backup
    echo "✅ 已备份到 .git/hooks/pre-commit.backup"
else
    echo "⚠️  未找到 pre-commit hook，无需操作"
fi

echo ""
echo "========================================"
echo "  ✅ Pre-commit Hook 已禁用"
echo "========================================"
echo ""
echo "现在可以正常提交代码了："
echo "  git add ."
echo "  git commit -m 'your message'"
echo ""
echo "如需重新启用，运行："
echo "  ./scripts/enable-precommit.sh"
echo ""