document.addEventListener('DOMContentLoaded', () => {
    const copyButton = document.getElementById('copy-button');
    const copyTarget = document.getElementById('copy-target');

    copyButton.addEventListener('click', () => {
        // Copy text to clipboard
        navigator.clipboard.writeText(copyTarget.placeholder).then(() => {
            // Provide feedback to user
            const originalText = copyButton.textContent;
            copyButton.textContent = 'Copied!';
            setTimeout(() => {
                copyButton.textContent = originalText;
            }, 2000);
        }).catch(err => {
            console.error('Error copying text: ', err);
        });
    });
});
