$(document).ready(function() {

  slickifyDropdown($(".items-dropdown"));

  $("#add-existing-item-button").click(function() {
    var itemId = $(".dd-selected-value")[0].value
    var proposalId = gon.proposalId
    $.ajax({
      url: '/proposals/' + proposalId + '/add_existing_item',
      type: "PUT",
      data: { item: {
        id: itemId, proposal_id: proposalId }
      }
    });
  });

  $(":radio").change(function() {
    debugger;
    $.ajax({
      url: $(this).parents('form')[0].action,
      type: "PUT",
      data: { item: {
        client_intention: $(this).val()
      }}
    })
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
