$(document).on('turbolinks:load', function() {
  $("#user_role").change(function() {
    if(this.checked) {
      $(".modal").modal();
      $("#sign-up-button").attr('disabled', 'disabled');
      if($("#consignment-policy-accepted-box").checked) {
        $("#sign-up-button").removeAttr('disabled');
      }
    } else {
      $("#sign-up-button").removeAttr('disabled');
    }
  });

  $("#consignment-policy-accepted-box").change(function() {
    if(this.checked) {
      $("#sign-up-button").removeAttr('disabled');
    }
  });
})
