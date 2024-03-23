document.addEventListener('DOMContentLoaded', function() {
    const defaultTab = document.getElementById('users-tab');
    if (!defaultTab.classList.contains('active')) {
      defaultTab.classList.add('active');
    }
  
    const defaultTabContent = document.getElementById('users-content');
    if (!defaultTabContent.classList.contains('active')) {
      defaultTabContent.classList.add('active');
    }
  });
  