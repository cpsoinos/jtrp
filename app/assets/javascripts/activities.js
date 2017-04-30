$(document).on('turbolinks:load', function() {

  $(".activity-list").infinitescroll({
    navSelector: "ul.pagination",
    nextSelector: "ul.pagination li a[rel=next]",
    itemSelector: ".activity"
  });

})
