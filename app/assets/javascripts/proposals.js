$(document).ready(function() {

  $("#new-client-button").click(function() {
    $("#new-client-form").toggleClass('hidden');
  });

  slickifyDropdown($(".items-dropdown"));

  $("#add-existing-item-button").click(function() {
    debugger;
    var itemId = $(".dd-selected-value")[0].value
    var proposalId = gon.proposalId
    $.ajax({
	    url: '/proposals/' + proposalId + '/add_existing_item',
	    type: "PUT",
	    data: { item: {
        id: itemId, proposal_id: proposalId }
      }
	  });
  })
})

function slickifyDropdown(selector) {
  selector.ddslick({
    data: JSON.parse(gon.items),
    imagePosition: "left",
    width: 300,
    selectText: "Choose an Item",
    onSelected: function(e) {
      hidden_field = $(e.selectedItem).parents(".dd-container").next();
      hidden_field.val(e.selectedData.value);
    }
  });
}
