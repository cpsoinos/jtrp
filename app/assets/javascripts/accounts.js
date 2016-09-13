$(".accounts.new").on('turbolinks:load', function() {
  $("#new-account-button").click(function() {
    $("#new-account-form").toggleClass('hidden');
  });
})
