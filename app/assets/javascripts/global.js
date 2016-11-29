$(document).on('turbolinks:load', function() {

  /* Fade out flash messages after 5 sec */
  $('.alert').delay(5000).fadeOut();

  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

  /* Initialize material design javascripts */
  $.material.init();

  var $tab = $($("a[role='tab']")[0])
  $tab.tab("show");

  $(".tablesorter").tablesorter( { sortList: [[1,0]] } );

  $("tr[data-link]").click(function() {
    window.location = $(this).data("link")
  })

});
