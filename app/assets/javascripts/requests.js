// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function requestStatus(event) {
  var $this = $(event.target);
  var report;

  $('.loading-request-result').empty().append('<img src="/images/js-run.gif" width="250" height="150"></img>');
  $('.download-link').addClass('disabled');

  $.ajax({
    type: 'GET',
    url: '/requests/' + $this.data('request-id') + '/status',
    success: function(result) {
      report = result.report;
      $('#request-status, #report-link').removeClass('hidden');

      $('.request-status').empty().append(
        '<div class="top-margin-5 ' + report['status_label'] + '">' + report['status'] + '</div>'
      );

      if (report['status'] === 'Complete') {
        $('.download-link').removeClass('disabled');
        $('.download-link').text('Download');
      }
    },
    error: function(error) {
      content = '<pre>Unknown Error, Please try again later</pre>';
    },
    complete: function() {
      $('.loading-request-result').empty();
    }
  });
}

function addTemplateLink() {
  var description = $('#request_description').attr('placeholder');
  var solution_id = $('#request_solution_id').val();

  $.ajax({
    type: 'GET',
    url: '/solutions/' + solution_id + '/prerequisite',
    success: function(result) {
      description = result.prerequisite;
    },
    error: function() {
      description = 'Select appropriate Solution first';
    },
    complete: function() {
      $('#request_description').val(description);
    }
  });
}

$(document).on('click', '.check-status-btn', function(event) { requestStatus(event); });
$(document).on('click', '#add-template-link', function() { addTemplateLink(); });
