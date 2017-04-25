$(document).on('turbolinks:load', function() {

  if (gon.jobs !== undefined) {
    var jobData = JSON.parse(gon.jobs)
  };

  slickifyDropdown($(".jobs-dropdown"), jobData);

  $("#job-selector-button").click(function(e) {
    e.preventDefault();
    $("#job-selector").toggleClass('hidden');
  });

})
