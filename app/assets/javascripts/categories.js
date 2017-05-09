$(document).on('turbolinks:load', function() {

  if (gon.toggleSelector != undefined) {
    $(gon.toggleSelector).collapse('show');
    $(gon.selectedSelector).css("border-right", "1px solid blue")
  }

  $.cloudinary.responsive();

})
