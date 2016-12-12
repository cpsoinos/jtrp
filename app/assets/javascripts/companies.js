$(document).on('turbolinks:load', function() {

  initMap();

  {
    jQuery('#slideshow0 > div').camera({
      alignment: "center",
      autoAdvance: true,
      mobileAutoAdvance: true,
      barDirection: "leftToRight",
      barPosition: "bottom",
      cols: 6,
      easing: "easeInOutExpo",
      mobileEasing: "easeInOutExpo",
      fx: "random",
      mobileFx: "random",
      gridDifference: 250,
      height: "auto",
      hover: true,
      loader: "pie",
      loaderColor: "#eeeeee",
      loaderBgColor: "#222222",
      loaderOpacity: 0.3,
      loaderPadding: 2,
      loaderStroke: 7,
      minHeight: "200px",
      navigation: true,
      navigationHover: true,
      mobileNavHover: true,
      opacityOnGrid: false,
      overlayer: true,
      pagination: true,
      pauseOnClick: true,
      playPause: true,
      pieDiameter: 38,
      piePosition: "rightTop",
      portrait: false,
      rows: 4,
      slicedCols: 12,
      slicedRows: 8,
      slideOn: "random",
      thumbnails: false,
      time: 7000,
      transPeriod: 1500,
      imagePath: 'images/'
    });
  }

});

function initMap() {
  var jtrp = {lat:42.75164559999999, lng:-71.20536419999996};
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 15,
    center: jtrp
  });
  var marker = new google.maps.Marker({
    position: jtrp,
    map: map
  });
}
