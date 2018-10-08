/**
 * Copies the scenario
 *
 * @param event The click event that triggered the function
 */
function copyScenario(event){
  copyId = $('#copy-scenario').find('option').filter(':selected').val();
  event.preventDefault();
  $.ajax({
    type: 'POST',
    url: '/scenarios/copy',
    data: { copy_id: copyId },
    success: function(result) {
      location.replace('/scenarios/' + result.scenario_id + '/edit');
    },
    error: function(error) {
      location.replace('/scenarios/new');
      sessionStorage.copyScenarioError = true;
    }
  });
}
/**
 * Saves the scenario
 *
 * @param event The click event that triggered the function
 */
function saveExecuteScenario(event) {
  var resultArea = $('.test-results');
  event.preventDefault();

  resultArea.empty().append(
    '<div class="text-center">' +
      '<span class="glyphicon text-center running-scenario-icon glyphicon-refresh glyphicon-refresh-animate"></span>' +
    '</div>'
  );
  sessionStorage.scenarioStatus = true;
  $('#save-scenario-form').submit();
}

function saveScenario(event) {
  sessionStorage.scenarioStatus = false;
  $('#save-scenario-form').submit();
}

/**
 * Runs the test scenario
 *
 * @param event The click event that triggered the function
 */
function runScenario() {
  var resultArea   = $('.test-results');
  sessionStorage.setItem('scenarioStatus',false);
  
  $('.dom-results').html('Nothing to show now');
  $('.developer-results').html('Nothing to show now');

  resultArea.removeClass('hidden');
  resultArea.empty().append(
    '<div class="text-center">' +
      '<span class="glyphicon text-center running-scenario-icon glyphicon-refresh glyphicon-refresh-animate"></span>' +
    '</div>'
  );
  var scenarioIdContainer = $('#scenario_id')[0];
  var scenarioId = scenarioIdContainer.dataset.scenario_id;
  status = 'Failed!';
  style = 'danger';
  $.ajax({
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

      resultArea.empty().append(
        '<div class="alert alert-' + style + '">' +
          '<strong>' + status + '</strong><br/>' +
          '<pre>' + result.test + '</pre>' +
        '</div>' +
        '<br/>' + screenshots
      );

      $('.dom-results').empty().append(result.dom_inspects);
      $('.developer-results').empty().append('<pre>' + result.content + '</pre>');
    },
    error: function(error) {
      resultArea.append('<div class="alert alert-danger text-center"><strong>An error has occurred</strong></div>');
    }
  });
}

function selectBoxEventHandler() {
  // select event handler for scenario type
  $('.select-box').on('change', function(event) {
    var $this = $(this);
    var stepId = $(this).attr('id').match(/scenario_scenario_steps_attributes_(.*)_step_type/)[1];

    // update step type for add in
    if (stepId.match(/_scenario_steps/)) {
      $this.attr('name', 'scenario[scenario_steps_attributes][' + stepId + '][step_type]');
      $this.parent().next().next().find('input').attr(
        'name', 'scenario[scenario_steps_attributes][' + stepId + '][_destroy]'
      );
    }

    var inputFields = '<input class="form-control" type="text"' +
      'name="scenario[scenario_steps_attributes][' + stepId + '][step_value]" ' +
        'id="scenario_scenario_steps_attributes_' + stepId + '_step_value">';

    var xPathBox = '<select class="form-control xpath_select">' +
      '<option value ="fill_with" selected=true>Fill in with</option>' +
        '<option value = "click">Click</option>' +
          '</select>';
    var value = $(this).val();
    if (value == 'dom_using_xpath') {
      inputFields = '<a class="col-sm-1 no-left-padding" data-target="#xpath_modal" data-toggle="modal">xPath</a>' +
      '<div class="col-sm-11 no-left-padding no-right-padding">' +
        inputFields.replace(/step_value/, 'step_value_key').replace(/_step_value/, '_step_value_key') + '<br/>' +
      '</div>' +
      '<div class="col-sm-1 no-left-padding">And</div>' +
      '<div class="col-sm-4 no-left-padding">' +
        xPathBox +
      '</div>' +
      '<div class="col-sm-7 no-left-padding no-right-padding">' +
        inputFields.replace(/step_value/, 'step_value_with').replace(/_step_value/, '_step_value_with') +
      '</div>';
    } else if (value == 'select_date') {
      inputFields = '<a class="col-sm-1 no-left-padding" data-target="#date_modal" data-toggle="modal">xPath</a>' +
      '<div class="col-sm-11 no-left-padding no-right-padding">' +
        inputFields.replace(/step_value/, 'step_value_key').replace(/_step_value/, '_step_value_key') + '<br/>' +
      '</div>' +
      '<div class="col-sm-1 no-left-padding">And</div>' +
      '<div class="col-sm-4 no-left-padding">' +
        xPathBox +
      '</div>' +
      '<div class="col-sm-7 no-left-padding no-right-padding">' +
        inputFields.replace(/step_value/, 'step_value_with').replace(/_step_value/, '_step_value_with') +
      '</div>'; 
    }  else if (value == 'select_time') {
      inputFields = '<a class="col-sm-1 no-left-padding" data-target="#date_modal" data-toggle="modal">xPath</a>' +
      '<div class="col-sm-11 no-left-padding no-right-padding">' +
        inputFields.replace(/step_value/, 'step_value_key').replace(/_step_value/, '_step_value_key') + '<br/>' +
      '</div>' +
      '<div class="col-sm-1 no-left-padding">And</div>' +
      '<div class="col-sm-4 no-left-padding">' +
        xPathBox +
      '</div>' +
      '<div class="col-sm-7 no-left-padding no-right-padding">' +
        inputFields.replace(/step_value/, 'step_value_with').replace(/_step_value/, '_step_value_with') +
      '</div>'; 
    } else if (value == 'import') {
      var importBox = '<div class="col-sm-6 no-left-padding">' +
        '<select class="import_select form-control" name="scenario[scenario_steps_attributes][' +
          stepId + '][step_value]" id="scenario_scenario_steps_attributes_' + stepId + '_step_value">';

      $.ajax({
        type: 'GET',
        url: '/imports_scenarios',
        success: function(data) {
          importBox += '<option>Select</option>';
          for(var i = 0; i < data.length; i++) {
            importBox += '<option value=' + data[i].id + '>' + data[i].name + '</option>';
          }
          importBox += '</select></div>';
          inputFields = importBox;
          inputFields += '<div class="import_link col-sm-6 no-left-padding" id="import_link_' + stepId + '"></div>';
          $this.parent().next('.value-wrapper').html(inputFields);
        }
      });
    } else if (value == 'fill_in' || value == 'select' || value == 'fill_in_dynamic' || value == 'fill_in_time' || value == 'fill_time') {
      inputFields = '<div class="col-sm-6 no-left-padding">' +
        inputFields.replace(/step_value/, 'step_value_key').replace(/_step_value/, '_step_value_key') +
      '</div>' +
      '<div class="col-sm-6 no-left-padding no-right-padding">' +
        inputFields.replace(/step_value/, 'step_value_with').replace(/_step_value/, '_step_value_with') +
      '</div>';
    } else if ($(this).val() == 'dom_inspector') {
      inputFields = inputFields.replace(/\>/, 'disabled>');
    } else if ($(this).val() == 'save_screenshot') {
      inputFields = inputFields.replace(/\>/, 'disabled>');
    } else if (value == 'add_delay') {
      inputFields = '<div class="col-sm-1 no-left-padding top-margin-7">for</div><div class="col-sm-2 no-left-padding">' +
        inputFields +
      '</div><div class="col-sm-1 top-margin-7 no-left-padding">Seconds</div>';
    }

    $(this).parent().next('.value-wrapper').html(inputFields);

    // call a xpath event handler on change
    if (value == 'dom_using_xpath' || value == 'select_date') {
      $('.xpath_select').change();
    }
  });

  // on load
  if ($('.xpath_select').exists()) {
    $('.xpath_select').change();
  }
}

function xPathSelector(event) {
  var target = $(event.target).parent().next();

  // empty the value for click and hide the xpath fill in value
  if ($(event.target).val() == 'click') {
    target.children().first().val('');
    target.hide();
  } else {
    target.show();
  }
}

function importScenarioSelector(event) {
  var scenarioId = $(event.target).val();
  var stepId = $(event.target).attr('id').match(/scenario_scenario_steps_attributes_(.*)_step_value/)[1];

  $.ajax({
    type: 'GET',
    url: '/imports_scenarios/' + scenarioId + '/link',
    success: function(result) {
      $('#import_link_' + stepId).html(result);
    }
  });
}

function importModal(event) {
  // Button that triggered the modal
  var button = $(event.relatedTarget)
  var scenarioId = button.data('id')
  var modal = $(event.target);

  $.ajax({
    type: 'GET',
    url: '/imports_scenarios/' + scenarioId,
    success: function success(result) {
      modal.find('.modal-body').html(result);
    }
  });
}

function importOnLoad() {
  var importBox = $('.import_select');
  if (importBox.html() !== undefined) {
    $.each(importBox, function(index, box) {
      $.ajax({
        type: 'GET',
        url: '/imports_scenarios',
        success: function(data) {
          for(var i = 0; i < data.length; i++) {
            $(box).append($('<option>', { value: data[i].id, text: data[i].name }));
          }

          $(box).val($(box).data('id'));
          $(box).change();
        }
      });
    });
  }
}

function initSelect2() {
  $('select').select2({ theme: 'bootstrap' });
}

$.fn.exists = function() { return this.length > 0; }

// Attach event listeners for scenario
$(document).on('nested:fieldAdded', function(event) { selectBoxEventHandler(); });
$(document).on('ready', function(event) { selectBoxEventHandler(); });
$(document).on('click', '#saveExecute-scenario', function(event) { saveExecuteScenario(event); });
$(document).on('click', '#save-scenario', function(event) { saveScenario(event); });
$(document).on('click', '.add-step', function() { initSelect2(); });
$(document).on('change', '.xpath_select', function(event) { xPathSelector(event); });
$(document).on('change', '.import_select', function(event) { importScenarioSelector(event); });
$(document).on('show.bs.modal', '#importModal', function (event) { importModal(event) });
$(document).on('click', '#copy-scenario-button', function(event) { copyScenario(event) });
// trigger events on page load
$(document).ready(function() {
  initSelect2();
  importOnLoad();
  if (sessionStorage.getItem('scenarioStatus') == 'true') {
    runScenario();
  }
  if (sessionStorage.getItem('copyScenarioError') == 'true') {
    $('#copy-scenario').append('<div class="alert alert-danger text-center"><strong>An error has occurred</strong></div>');
    sessionStorage.setItem('copyScenarioError',false);  
  }
});
