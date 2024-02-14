// Controls functionality behind modal

$(document).ready(function () {
    $("#filterButton").click(function () {
        $("#filterModal").modal('show');
    });

    // Update filter button text when select field value changes
    $(".sort-select").on("change", function () {
        var selectField = $(this);
        var selectedOption = selectField.find("option:selected").text();
        var targetButton = $("#" + selectField.data("button-id"));
        targetButton.text("Filter Options (" + selectedOption + ")");
    });
});

// Reset all filter options
$("#resetFiltersButton").on("click", function () {
    $(".sort-select").val(""); // Clear selected options
    $("#filterButton").text("Filter Options"); // Reset button text
});