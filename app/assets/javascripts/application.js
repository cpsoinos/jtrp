// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootsy
//= require jquery.remotipart
//= require bootstrap.min
//= require bootstrap-datepicker
//= require jasny-bootstrap.min
//= require jquery.dropdown
//= require jquery.flexisel
//= require jquery.tagsinput
//= require material-kit
//= require material.min
//= require nouislider.min
//= require best_in_place
//= require dropzone
//= require jquery-ddslick
//= require flashcanvas
//= require json2.min
//= require jquery-readyselector
//= require masonry.pkgd.min
//= require imagesloaded.pkgd.min
//= require react
//= require react_ujs
//= require components
//= require jsapi
//= require chartkick
//= require sweetalert
//= require sweet-alert-confirm
//= require jquery.geocomplete.min
//= require instafeed.min
//= require cloudinary
//= require_tree .

$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

  $.material.init();
  // $.material.options = {
  //   "withRipples": ".btn:not(.btn-link), .card-image, .navbar a:not(.withoutripple), .nav-tabs a:not(.withoutripple), .withripple",
  //   "inputElements": "input.form-control, .input:not(.dropzone), textarea.form-control, select.form-control",
  //   "checkboxElements": ".checkbox > label > input[type=checkbox]",
  //   "radioElements": ".radio > label > input[type=radio]"
  // }
  // $.material.ripples();
  // $.material.input();
  // $.material.checkbox();
  // $.material.radio();
});
