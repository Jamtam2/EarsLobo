// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import 'controllers'
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import 'bootstrap'
import autosize from 'autosize'

document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  autosize(document.querySelectorAll('textarea'));
})

function hideInput() {
  var colDiv = document.getElementById("normalCol");
  colDiv.style.display === "block" ? colDiv.style.display = 'none' : colDiv.style.display = 'block';
}





document.addEventListener("turbolinks:load", function() {
  // reset the active tab when the page is loaded
  $(".tab-content.active").removeClass("active");
  $(".tab.active").removeClass("active");

  // set the active tab based on the URL anchor
  var tabAnchor = window.location.hash.substring(1);
  $("#" + tabAnchor + "-content").addClass("active");
  $("#" + tabAnchor + "-tab").addClass("active");

  // update the URL anchor when a tab is clicked
  $(".tab").on("click", function() {
    var tabAnchor = $(this).attr("id");
    window.location.hash = tabAnchor;
  });
});

