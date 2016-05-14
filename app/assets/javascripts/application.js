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
//= require bootstrap
//= require bootstrap-material-design
//= require best_in_place
//= require dropzone
//= require jquery-ddslick
//= require flashcanvas
//= require jquery.signaturepad.min
//= require json2.min
//= require jquery-readyselector
//= require_tree .

$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

  // $.material.init()
  $.material.ripples();
  $.material.checkbox();
  $.material.radio();
});
