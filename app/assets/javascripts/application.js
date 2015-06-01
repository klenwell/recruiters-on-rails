// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require bootstrap-typeahead-rails
//= require_tree .

/*
 * Datepicker
 */
var datepickerReady = function() {

  $('.input-group.date').datepicker({
    format: "yyyy-mm-dd",
    todayHighlight: true,
    autoclose: true
  });
};

$(document).ready(datepickerReady);
$(document).on('page:load', datepickerReady);
