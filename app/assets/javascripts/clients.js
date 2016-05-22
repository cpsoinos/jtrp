$(document).ready(function() {

  $("#new-client-button").click(function() {
    $("#new-client-form").toggleClass('hidden');
  });

  var $clientGrid = $('.client-grid').masonry({
    columnWidth: '.client-grid-sizer',
    itemSelector: '.client-grid-item',
    percentPosition: true,
  });
  // layout Masonry after each image loads
  $clientGrid.imagesLoaded().progress( function() {
    $clientGrid.masonry('layout');
  });


});
