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
  });

  handleSignatures();

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

function handleSignatures() {
  var options = {
    drawOnly: true
  }

  if(gon.signatures.manager === undefined) {
    $('#manager-signed').signaturePad(options)
  } else {
    fillSignatures("manager", gon.signatures.manager)
  };

  if(gon.signatures.client === undefined) {
    $('#client-signed').signaturePad(options)
  } else {
    fillSignatures("client", gon.signatures.client)
  };
}

function fillSignatures(selector, sig) {
  $(('#' + selector + '-signed') ).signaturePad({displayOnly:true}).regenerate(sig);
}
