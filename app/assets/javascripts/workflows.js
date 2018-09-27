// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function saveWorkflow(event) {
  var resultArea = $('.test-results');
  event.preventDefault();
  resultArea.empty().append(
    '<div class="text-center">' +
      '<span class="glyphicon text-center running-scenario-icon glyphicon-refresh glyphicon-refresh-animate"></span>' +
    '</div>'
  );
  sessionStorage.workflowStatus = true;
  $('#save-workflow-form').submit();
}

function runWorkflow() {
  var resultArea   = $('.test-results');
  sessionStorage.setItem('workflowStatus',false);
  
  $('.dom-results').html('Nothing to show now');
  $('.developer-results').html('Nothing to show now');

  $('.workflow-scenarios').attr('disabled', true);
  resultArea.removeClass('hidden');
  resultArea.empty();
  $('.load-icon').empty().append(
    '<div class="text-center">' +
      '<span class="glyphicon text-center running-scenario-icon glyphicon-refresh glyphicon-refresh-animate"></span>' +
    '</div>'
  );
  $('.workflow-scenarios').find('option').filter(':selected').each(function () {
    var scenarioId = $(this).val();
    status = 'Failed!';
    style = 'danger';
    $.ajax({
      async: false,
      type: 'GET',
      url: '/scenarios/' + scenarioId + '/generate',
      success: function(result) {
        if (result.passed === true) {
          status = 'Success!';
          style = 'success';
        }

        var screenshots = '<h4>Screenshots</h4>';
        $.each(result.screenshots, function( index, screenshot ){
          screenshots += '<br/><div class="label label-default">Screenshot ' + (index + 1) + '</div><br/><br/>' +
            '<div><img src="' + screenshot + '"></img></div>';
        });

        resultArea.append(
          '<div class="alert alert-' + style + '">' +
            '<strong>' + status + '</strong><br/>' +
            '<pre>' + result.test + '</pre>' +
          '</div>' +
          '<br/>' + screenshots
        );
        $('.dom-results').append(result.dom_inspects);
        $('.developer-results').append('<pre>' + result.content + '</pre>');
      },
      error: function(error) {
        resultArea.append('<div class="alert alert-danger text-center"><strong>An error has occurred</strong></div>');
      }
    });
   });
  $('.load-icon').empty();
  $('.workflow-scenarios').attr('disabled', false);
}

function initSelect2() {
  $('select').select2({ theme: 'bootstrap' });
}

$(document).on('click', '.add-test', function() { initSelect2(); });
$(document).on('click', '#save-workflow', function(event) { saveWorkflow(event); });

$(document).ready(function() {
  initSelect2();
  if(sessionStorage.getItem('workflowStatus') == 'true') {
    runWorkflow();
  }
});
