document.addEventListener('turbolinks:load', function () {
    let localModeratorRadioButton = document.getElementById('localModerator');
    let regularUserRadioButton = document.getElementById('regularUser');
    let locationModeratorRadioButton = document.getElementById('locationModerator');


    localModeratorRadioButton.addEventListener('change', toggleFields);
    regularUserRadioButton.addEventListener('change', toggleFields);
    locationModeratorRadioButton.addEventListener('change', toggleFields);


    toggleFields(); // Initialize the form with the correct fields visible
});

function toggleFields() {
    let localModerator = document.getElementById('localModerator').checked;
    let regularUser = document.getElementById('regularUser').checked;
    let locationModerator = document.getElementById('locationModerator').checked;


    let registrationKeyField = document.getElementById('registrationKeyField');
    let signUpCodeField = document.getElementById('signUpCodeField');

    registrationKeyField.style.display = localModerator || regularUser ? 'block' : 'none';
    signUpCodeField.style.display = regularUser || locationModerator ? 'block' : 'none';
}
