$(document).on('turbolinks:load', function() {

  // sort photos
  $('#photos').sortable({
    update: function() {
      return $.post($(this).data('update-url'), $(this).sortable('serialize'));
    }
  });

  if (document.getElementById("proposal-photos-form") != undefined) {
    initPhotoUploadWidget('photos[]', $("#proposal-photos-form"), 'Select Images', true);
  }

  if (document.getElementById("item-photos-form") != undefined) {
    initPhotoUploadWidget('item[initial_photos][]', $("#item-photos-form"), 'Select Images');
  }

  if (document.getElementById("contact-us-form") != undefined) {
    initPhotoUploadWidget('photos[]', $("#contact-us-form"), 'Add Photos');
  }

})

function initPhotoUploadWidget(fieldName, $form, caption, submitOnSuccess) {
  $('#upload_widget_opener').cloudinary_upload_widget(
    {
      upload_preset:   'widget',
      sources:         ['local', 'camera', 'google_photos', 'dropbox', 'facebook'],
      theme:           'white',
      button_class:    'btn btn-primary',
      button_caption:  caption,
      multiple:        true,
      resource_type:   'image',
      show_powered_by: false,
      field_name:      fieldName
    },
    function(error, result) {
      if (error) {
        console.log(error, result)
      } else if (submitOnSuccess) {
        $form.submit();
      }
    }
  );
}
