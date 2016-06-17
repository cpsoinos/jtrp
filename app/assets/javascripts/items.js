$(document).ready(function() {

  $("#add-existing-item-button").click(function() {
    var itemId = $(".dd-selected-value")[0].value
    var proposalId = gon.proposalId
    $.ajax({
      url: '/items/' + itemId,
      type: "PUT",
      data: { item: {
        id: itemId, proposal_id: proposalId }
      }
    });
  });

  $(".remove-existing-item-button").click(function() {
    var itemId = this.dataset.itemId
    $.ajax({
      url: '/items/' + itemId,
      type: "DELETE"
    });
  });

  $(":radio.intention-selector").change(function() {
    var intention = $(this).val()
    $.ajax({
      url: $(this).parents('form')[0].action,
      type: "PUT",
      data: { item: {
        client_intention: intention
      }}
    })
  });

  // init Masonry
  var $grid = $('.grid').masonry({
    columnWidth: '.grid-sizer',
    itemSelector: '.grid-item',
    percentPosition: true
  });
  // layout Masonry after each image loads
  $grid.imagesLoaded().progress( function() {
    $grid.masonry('layout');

    // init masonry within panels
    var $itemGrid = $('.item-grid').masonry({
      itemSelector: '.item-grid-item',
      columnWidth: '.item-grid-sizer',
      gutter: 10,
      percentPosition: true
    });
  });

  //Reinitialize masonry inside each panel after the relative tab link is clicked -
	$('a[data-toggle=tab]').each(function () {
		var $this = $(this);

		$this.on('shown.bs.tab', function () {

      $grid.imagesLoaded().progress( function() {
        $grid.masonry('layout');
      });
		}); //end shown
	});  //end each

});

$(".items.index").ready(function() {
  var $tab = $($("a[role='tab']")[0])
  $tab.tab("show");
})
