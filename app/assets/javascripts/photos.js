$(document).on('turbolinks:load', function() {

  // sort photos
  $('#photos').sortable({
    // handle: '.handle',
    update: function() {
      return $.post($(this).data('update-url'), $(this).sortable('serialize'));
    }
  });

})
