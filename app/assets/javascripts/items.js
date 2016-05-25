$(document).ready(function() {

  if (gon.items !== undefined) {
    var itemData = JSON.parse(gon.items)
  };
  slickifyDropdown($(".items-dropdown"), itemData);

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
    var proposalId = null
    $.ajax({
      url: '/items/' + itemId,
      type: "PUT",
      data: { item: {
        id: itemId, proposal_id: proposalId }
      }
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

  $(":radio.offer-selector").change(function() {
    var offer = $(this).val()
    $.ajax({
      url: $(this).parents('form')[0].action,
      type: "PUT",
      data: { item: {
        offer_type: offer
      }},
      complete: function(xhr, textStatus) {
        if (xhr.status == 200) {
          var itemId = this.url.split("/").slice(-1).pop()
          var offer = this.data.split("=").slice(-1).pop()
          if (offer == "purchase") {
            $(("#best_in_place_item_" + itemId + "_listing_price")).html("$0.00");
            $(("#best_in_place_item_" + itemId + "_minimum_sale_price")).html("$0.00");
          } else {
            $(("#best_in_place_item_" + itemId + "_purchase_price")).html("$0.00");
          }
        }
      }
    });
  });

  // init Masonry
  var $grid = $('.grid').masonry({
    columnWidth: '.grid-sizer',
    itemSelector: '.grid-item',
    percentPosition: true,
  });
  // layout Masonry after each image loads
  $grid.imagesLoaded().progress( function() {
    $grid.masonry('layout');
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
  var $tab = $($("a[role='tab'")[0])
  $tab.tab("show");
})

var slickifyDropdown = function(selector, items) {
  selector.ddslick({
    data: items,
    imagePosition: "left",
    width: 280,
    selectText: "Choose an Item"
  });
}
