// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var onReady = function() {

  $('table.table a#ping').on('click', function(event) {
    var recruiterId = $(this).closest('tr.recruiter-id').attr('id').split('-')[1];
    console.debug('clicked', recruiterId, $(this), event);
  });

  // Source: http://stackoverflow.com/q/30019692/1093087
  // initialize bloodhound engine
  var searchSelector = 'div.search.recruiters input.typeahead';

  var bloodhound = new Bloodhound({
    datumTokenizer: function (d) {
      return Bloodhound.tokenizers.whitespace(d.value);
    },
    queryTokenizer: Bloodhound.tokenizers.whitespace,

    // sends ajax request to remote url where %QUERY is user input
    remote: '/recruiters/typeahead/%QUERY',
    limit: 50
  });
  bloodhound.initialize();

  // initialize typeahead widget and hook it up to bloodhound engine
  // #typeahead is just a text input
  $(searchSelector).typeahead(null, {
    displayKey: 'email',
    source: bloodhound.ttAdapter()
  });

  // this is the event that is fired when a user clicks on a suggestion
  $(searchSelector).bind('typeahead:selected', function(event, datum, name) {
    //console.debug('Suggestion clicked:', event, datum, name);
    window.location.href = '/recruiters/' + datum.id;
  });

  // Modal for blacklist button
  $('div#blacklist-modal').on('show.bs.modal', function(e) {
    var color = $(e.relatedTarget).hasClass('graylist') ? 'gray' : 'black';
    console.debug('show', color, $(this), e);
    $('input#blacklist_color').val(color);
  })

  $('div#blacklist-modal').on('hidden.bs.modal', function(e) {
    console.debug('hidden', $(this), e);
  });

  $('div#blacklist-modal form').on('submit', function(e) {
    console.debug('on submit', e);
    $('div#blacklist-modal').modal('hide');
    //return false;
  })
};

$(document).ready(onReady);
$(document).on('page:load', onReady);
