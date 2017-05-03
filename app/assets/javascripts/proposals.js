$(document).on('turbolinks:load', function() {

  var $grid = $(".grid");

  if (gon.jobs !== undefined) {
    var jobData = JSON.parse(gon.jobs)
  };

  slickifyDropdown($(".jobs-dropdown"), jobData);

  $("#job-selector-button").click(function(e) {
    e.preventDefault();
    $("#job-selector").toggleClass('hidden');
  });

  // Upload images to Cloudinary
  $(function() {
    if($.fn.cloudinary_fileupload !== undefined) {
      $("input.cloudinary-fileupload[type=file]").cloudinary_fileupload({
        dropZone: "#direct_upload",
        start: function (e) {
          $(".status").text("Starting upload...");
        },
        progress: function (e, data) {
          $(".status").text("Uploading... " + Math.round((data.loaded * 100.0) / data.total) + "%");
        },
        fail: function (e, data) {
          $(".status").text("Upload failed");
        }
      });
    }
  });

  $('.cloudinary-fileupload').bind('fileuploadprogress', function(e, data) {
    $('.progress_bar').css('width', Math.round((data.loaded * 100.0) / data.total) + '%');
  });

  $('.cloudinary-fileupload').bind('cloudinarydone', function(e, data) {
    // Set page number in form if file is a PDF
    if ($("#agreement_pdf_pages") != undefined) {
      $("#agreement_pdf_pages").val(data.result.pages)
    };
    // Add image previews
    var $img = $("<div class='col-xs-4 grid-item'><img src='" + $.cloudinary.url(data.result.public_id, { fetch_format: 'auto', crop: "fit" } ) + "' id=" + data.result.public_id + " class='img img-raised thumb'></div>");

    $grid.prepend( $img ).masonry( 'prepended', $img )

    // Handle deletion
    $('.delete_by_token').click(function(e) {
      var $deleteButton = $(this)
      var previewId = $deleteButton.data('preview_id')
      var $previewImage = $("#" + previewId)
      var deleteToken = $deleteButton.data('delete_token')
      e.preventDefault();
      $.cloudinary.delete_by_token(deleteToken).done(function(){
        $previewImage.remove();
        $deleteButton.remove();
      }).fail(function() {
        $('.status').text("Cannot delete image");
      });
    });
    // Remove status message
    $(".status").html("");
    return true;
  });


})
