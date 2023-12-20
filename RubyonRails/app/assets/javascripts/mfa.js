document.addEventListener("DOMContentLoaded", function() {
    // You can add interactivity here if needed
    // For example, focus on the MFA code input field when the page loads
    const mfaCodeInput = document.querySelector('.form-control');
    if (mfaCodeInput) mfaCodeInput.focus();
  });
  