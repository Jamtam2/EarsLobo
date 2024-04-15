document.addEventListener('turbolinks:load', function () {
    let localModeratorRadioButton = document.getElementById('localModerator');
    let regularUserRadioButton = document.getElementById('regularUser');

    localModeratorRadioButton.addEventListener('change', toggleFields);
    regularUserRadioButton.addEventListener('change', toggleFields);

    toggleFields(); // Initialize the form with the correct fields visible
});

function toggleFields() {
    let localModerator = document.getElementById('localModerator').checked;
    let regularUser = document.getElementById('regularUser').checked;

    let registrationKeyField = document.getElementById('registrationKeyField');
    let signUpCodeField = document.getElementById('signUpCodeField');

    // registrationKeyField.style.display = localModerator || regularUser ? 'block' : 'none';
    registrationKeyField.style.display = localModerator ? 'block' : 'none';
    signUpCodeField.style.display = regularUser ? 'block' : 'none';
}
