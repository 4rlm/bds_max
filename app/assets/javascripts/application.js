// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .


function checkAll(check_all) {
  // Pass in a named "Check All" checkbox that appears on the same form where All
  // checkboxes should be checked.

  // Loop through an array containing ALL inputs on the same form as check_all
  var inputs = check_all.form.getElementsByTagName('input');
  for (var i = 0; i < inputs.length; i++) {
    // Only work on checkboxes, and NOT on the "Check All" checkboxes
    if (inputs[i].type == 'checkbox') {
      if (check_all.checked == true) {
        inputs[i].checked = true;
      } else {
        inputs[i].checked = false;
      }
    }
  }
}
