$(document).on('turbolinks:load', function() {

  // var slider2 = document.getElementById('sliderRefine');
  //
  // noUiSlider.create(slider2, {
  //   start: [42, 880],
  //   connect: true,
  //   range: {
  //     'min': [30],
  //     'max': [900]
  //   }
  // });
  //
  // var limitFieldMin = document.getElementById('price-left');
  // var limitFieldMax = document.getElementById('price-right');
  //
  // slider2.noUiSlider.on('update', function(values, handle) {
  //   if (handle) {
  //     limitFieldMax.innerHTML = $('#price-right').data('currency') + Math.round(values[handle]);
  //   } else {
  //     limitFieldMin.innerHTML = $('#price-left').data('currency') + Math.round(values[handle]);
  //   }
  // });

  if (document.getElementById("contactUsMap") != undefined) {
    initMap();
  };
  // materialKitDemo.initContactUsMap();


  setTimeout(function() {
    $('.alert').slideUp();
  }, 5000);

});

var initMap = function() {
  var myLatlng = new google.maps.LatLng(42.7516009, -71.2076055);
  var mapOptions = {
    zoom: 14,
    center: myLatlng,
    styles: [{
      "featureType": "water",
      "stylers": [{
        "saturation": 43
      }, {
        "lightness": -11
      }, {
        "hue": "#0088ff"
      }]
    }, {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [{
        "hue": "#ff0000"
      }, {
        "saturation": -100
      }, {
        "lightness": 99
      }]
    }, {
      "featureType": "road",
      "elementType": "geometry.stroke",
      "stylers": [{
        "color": "#808080"
      }, {
        "lightness": 54
      }]
    }, {
      "featureType": "landscape.man_made",
      "elementType": "geometry.fill",
      "stylers": [{
        "color": "#ece2d9"
      }]
    }, {
      "featureType": "poi.park",
      "elementType": "geometry.fill",
      "stylers": [{
        "color": "#ccdca1"
      }]
    }, {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [{
        "color": "#767676"
      }]
    }, {
      "featureType": "road",
      "elementType": "labels.text.stroke",
      "stylers": [{
        "color": "#ffffff"
      }]
    }, {
      "featureType": "poi",
      "stylers": [{
        "visibility": "off"
      }]
    }, {
      "featureType": "landscape.natural",
      "elementType": "geometry.fill",
      "stylers": [{
        "visibility": "on"
      }, {
        "color": "#b8cb93"
      }]
    }, {
      "featureType": "poi.park",
      "stylers": [{
        "visibility": "on"
      }]
    }, {
      "featureType": "poi.sports_complex",
      "stylers": [{
        "visibility": "on"
      }]
    }, {
      "featureType": "poi.medical",
      "stylers": [{
        "visibility": "on"
      }]
    }, {
      "featureType": "poi.business",
      "stylers": [{
        "visibility": "simplified"
      }]
    }],
    scrollwheel: false, //we disable de scroll over the map, it is a really annoing when you scroll through page
  }
  var map = new google.maps.Map(document.getElementById("contactUsMap"), mapOptions);

  var marker = new google.maps.Marker({
    position: myLatlng,
    title: "Just the Right Piece"
  });
  marker.setMap(map);
};
