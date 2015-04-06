// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var onReady = function() {

  $('table.table a#ping').on('click', function(event) {
    var recruiterId = $(this).closest('tr.recruiter-id').attr('id').split('-')[1];
    console.debug('clicked', recruiterId, $(this), event);
  });

};

$(document).ready(onReady);
$(document).on('page:load', onReady);
