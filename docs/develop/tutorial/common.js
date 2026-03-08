// 共享JavaScript

// 复制代码功能
function copyCode(button) {
    const code = button.previousElementSibling.textContent;
    navigator.clipboard.writeText(code).then(() => {
        const originalText = button.textContent;
        button.textContent = '已复制！';
        button.style.background = '#28a745';
        setTimeout(() => {
            button.textContent = originalText;
            button.style.background = '#667eea';
        }, 2000);
    });
}

// 滚动到顶部
function scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// 页面加载动画
window.addEventListener('load', () => {
    document.querySelectorAll('.fade-in').forEach((element, index) => {
        element.style.animationDelay = `${index * 0.1}s`;
    });
});