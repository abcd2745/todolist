#!/bin/bash
# =============================================================================
# Git Commit 包装脚本 - 自动处理 Pre-commit Hook
# =============================================================================
# 功能：智能处理 git commit，可选择是否绕过 pre-commit
# =============================================================================

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 显示帮助信息
show_help() {
    echo "用法: $0 [选项] -m '提交信息'"
    echo ""
    echo "选项:"
    echo "  -m, --message   提交信息（必需）"
    echo "  -s, --skip      跳过 pre-commit 检查"
    echo "  -h, --help      显示帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 -m '添加新功能'           # 正常提交（会检查）"
    echo "  $0 -s -m '添加文档'          # 跳过检查提交"
    echo ""
}

# 解析参数
SKIP_HOOK=false
COMMIT_MSG=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--message)
            COMMIT_MSG="$2"
            shift 2
            ;;
        -s|--skip)
            SKIP_HOOK=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            show_help
            exit 1
            ;;
    esac
done

# 检查是否提供了提交信息
if [ -z "$COMMIT_MSG" ]; then
    echo "❌ 错误：必须提供提交信息"
    echo ""
    show_help
    exit 1
fi

# 执行提交
if [ "$SKIP_HOOK" = true ]; then
    echo -e "${YELLOW}⚠️  跳过 pre-commit 检查${NC}"
    git commit --no-verify -m "$COMMIT_MSG"
else
    echo -e "${GREEN}✅ 执行正常提交（包含 pre-commit 检查）${NC}"
    git commit -m "$COMMIT_MSG"
fi

echo ""
echo -e "${GREEN}✅ 提交成功！${NC}"