$(document).on('turbolinks:load', function() {

  $(".activity-list").infinitescroll({
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
  });

})

var spinner = '<div class="loading-spinner"> <div class="text-center"> <div style="margin: auto;"> <svg class="spinner" height="65px" viewBox="0 0 66 66" width="65px" xmlns="http://www.w3.org/2000/svg"> <circle class="path" cx="33" cy="33" fill="none" r="30" stroke-linecap="round" stroke-width="6"></circle> </svg> </div></div></div>'
