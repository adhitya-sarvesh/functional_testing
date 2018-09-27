function addPrerequisiteLink(event) {
  event.preventDefault();
  var description = $('.prerequisite_description').attr('placeholder');

  $('.prerequisite_description').val(description);
}

$(document).on('click', '#add-prerequisite-link', function(event) { addPrerequisiteLink(event); });
