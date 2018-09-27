function initTags(event) {
  var tagcount = 0;
  $(event.target).tagsInput({
    'height': '70px',
    'width': '100%',
    'interactive': true,
    'defaultText': 'Add Tags (3 to 20 characters)',
    'minChars': 3,
    'maxChars': 20,
    'placeholderColor': '#aaa',
    onAddTag: function(elem, elem_tags) {
      tagcount += $(this).length;
      if (tagcount > 5) {
        alert('Only 5 tags allowed ...!');
        $(this).removeTag(elem);
      }
    },
    onRemoveTag: function() {
      tagcount -= $(this).length;
    }
  });

  // TODO: remove this id dependency
  $('#scenario_tag_list_tag').addClass('form-control');
}

$(document).on('change', '.tags-input', function(event) { initTags(event); });
$(document).ready(function() { $('.tags-input').change(); });
