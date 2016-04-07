$(document).ready(function() {

  $("#new-vendor-button").click(function() {
    $("#new-vendor-form").toggleClass('hidden');
  });

  slickifyDropdown($(".items-dropdown"));

  $("#add-existing-item-button").click(function() {
    var itemId = $(".dd-selected-value")[0].value
    var purchaseOrderId = gon.purchaseOrderId
    $.ajax({
	    url: '/purchase_orders/' + purchaseOrderId + '/add_existing_item',
	    type: "PUT",
	    data: { item: {
        id: itemId, purchase_order_id: purchaseOrderId }
      }
	  });
  })
});

function slickifyDropdown(selector) {
  if (gon.items !== undefined) {
    var itemData = JSON.parse(gon.items)
  };
  selector.ddslick({
    data: itemData,
    imagePosition: "left",
    width: 300,
    selectText: "Choose an Item"
  });
}
