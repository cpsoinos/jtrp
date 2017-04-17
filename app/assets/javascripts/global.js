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

  // Fix modals showing behind backdrop
  $('.modal-dialog').parent().on('show.bs.modal', function(e) {
    $(e.relatedTarget.attributes['data-target'].value).appendTo('body');
  })

});
