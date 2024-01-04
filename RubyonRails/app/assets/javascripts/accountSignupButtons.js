document.addEventListener('turbolinks:load', function () {
    let localModeratorRadioButton = document.getElementById('localModerator');
    let regularUserRadioButton = document.getElementById('regularUser');

    localModeratorRadioButton.addEventListener('change', toggleFields);
    regularUserRadioButton.addEventListener('change', toggleFields);

    // Initialize the form with the correct fields visible
    toggleFields();
});

function toggleFields() {
    let localModerator = document.getElementById('localModerator').checked;
    let regularUser = document.getElementById('regularUser').checked;
    document.getElementById('registrationKeyField').style.display = localModerator ? 'block' : 'none';
    document.getElementById('signUpCodeField').style.display = regularUser ? 'block' : 'none';
}
