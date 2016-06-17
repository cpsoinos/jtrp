$(".proposals.new").ready(function() {

  if (gon.jobs !== undefined) {
    var jobData = JSON.parse(gon.jobs)
  };

  slickifyDropdown($(".jobs-dropdown"), jobData);

  $("#job-selector-button").click(function() {
    $("#job-selector").toggleClass('hidden');
  });

})

$(".proposals").ready(function() {
  $('.best_in_place').click(function() {
    $(this).closest('.grid-item').find('.panel-heading').removeClass('primary-lighter').addClass('complement-lighter');
  })
})
