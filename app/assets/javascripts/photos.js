$(document).on('turbolinks:load', function() {

  // sort photos
  $('#photos').sortable({
    update: function() {
      return $.post($(this).data('update-url'), $(this).sortable('serialize'));
    }
  });

  if (document.getElementById("proposal-photos-form") != undefined) {
    initPhotoUploadWidget('photos[]', $("#proposal-photos-form"), true);
  }

  if (document.getElementById("item-photos-form") != undefined) {
    initPhotoUploadWidget('item[initial_photos][]', $("#item-photos-form"));
  }

})

function initPhotoUploadWidget(fieldName, $form, submitOnSuccess) {
  $('#upload_widget_opener').cloudinary_upload_widget(
    {
      upload_preset: 'widget',
      sources: ['local', 'camera'],
      theme: 'white',
      button_class: 'btn btn-primary',
      button_caption: 'Select Images',
      multiple: true,
      resource_type: 'image',
      show_powered_by: false,
      field_name: fieldName
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
