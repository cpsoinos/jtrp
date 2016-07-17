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

  $("#client_address_1").geocomplete({
    map: "#job-map",
    details: "form",
    detailsAttribute: "data-geo",
    mapOptions: {
      center: new google.maps.LatLng({lat:42.7516009, lng:-71.2076055})
    }
  });

});
