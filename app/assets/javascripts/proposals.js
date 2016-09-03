$(".proposals.new").ready(function() {

  if (gon.jobs !== undefined) {
    var jobData = JSON.parse(gon.jobs)
  };

  slickifyDropdown($(".jobs-dropdown"), jobData);

  $("#job-selector-button").click(function() {
    $("#job-selector").toggleClass('hidden');
  });

})
