$(".proposals.new").ready(function() {

  if (gon.jobs !== undefined) {
    var jobData = JSON.parse(gon.jobs)
  };

  slickifyDropdown($(".jobs-dropdown"), jobData);

  $("#job-selector-button").click(function() {
    $("#job-selector").toggleClass('hidden');
  });

  // var pusher = new Pusher('578ca2dcf31e4a2f08dd', {
  //   encrypted: true
  // });
  //
  // var channelName = "proposal" + gon.proposalId
  // var channel = pusher.subscribe(channelName)
  //
  // channel.bind('new_item', function(data) {
  //   $("data.item").appendTo("#proposal-item-list");
  // });

})

$(".proposals").ready(function() {
  $('.best_in_place').click(function() {
    $(this).closest('.grid-item').find('.panel-heading').removeClass('primary-lighter').addClass('complement-lighter');
  })
})
