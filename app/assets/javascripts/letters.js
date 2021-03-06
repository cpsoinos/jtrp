$(document).on('turbolinks:load', function() {

  // Dynamically create letter pdf modals
  $("#letter-pdf-modal").on('shown.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var category = button.data('category') // Extract info from data-* attributes
    var url = button.data('url') // Extract info from data-* attributes
    var modal = $(this)
    modal.find('.modal-title').text(category);
    modal.find('img').attr("src", url);
    centerModal();
  })


});

function centerModal() {
  $(this).css('display', 'block');
  var $dialog = $(this).find(".modal-dialog");
  var offset = ($(window).height() - $dialog.height()) / 2;
  $dialog.css("margin-top", offset);
}
