$(document).on('turbolinks:load', function() {

  convertTimestamps();
  initInfiniteScroll($(".activity-list"));

})

var spinner = '<div class="loading-spinner"> <div class="text-center"> <div style="margin: auto;"> <svg class="spinner" height="65px" viewBox="0 0 66 66" width="65px" xmlns="http://www.w3.org/2000/svg"> <circle class="path" cx="33" cy="33" fill="none" r="30" stroke-linecap="round" stroke-width="6"></circle> </svg> </div></div></div>'

function initInfiniteScroll(selector) {
  return selector.infinitescroll({
    navSelector: "ul.pagination",
    nextSelector: "ul.pagination li a[rel=next]",
    itemSelector: ".activity",
    loading: {
      // Replace progress bar with miniscule, transparent img
      img: 'data:image/gif;base64,R0lGODlhAQABAHAAACH5BAUAAAAALAAAAAABAAEAAAICRAEAOw==',
      msgText: spinner,
      finishedMsg: '<div class="text-center"><em>No more activities meeting this criteria.</em></div>'
    },
    bufferPx: 150,
  }, function() {
    $(".activity-timestamp").each(function(index, value) {
      convertRelative($(this));
    });
  });
}

// convert timestamp in data-attribute to show correct time while allowing rails to use fragment caching
function convertTimestamps() {
  $(".activity-timestamp").each(function(index, value) {
    convertRelative($(this));
  });
}

function convertRelative($timestamp) {
  var time = $timestamp.data("timestamp");
  var relativeTime = moment(time).calendar();
  $timestamp.html(relativeTime);
}
