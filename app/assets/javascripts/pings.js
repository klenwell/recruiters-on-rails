// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var onReady = function() {

  $('body.pings .input-group.date').datepicker({
    format: "yyyy-mm-dd",
    autoclose: true
  });

};

$(document).ready(onReady);
$(document).on('page:load', onReady);
