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

  $(":radio").change(function() {
    $.ajax({
      url: $(this).parents('form')[0].action,
      type: "PUT",
      data: { item: {
        client_intention: $(this).val()
      }}
    })
  });

  // init Masonry
  var $grid = $('.grid').masonry({
    // options...
    columnWidth: '.grid-sizer',
    itemSelector: '.grid-item',
    percentPosition: true,
    // gutter: 10
  });
  // layout Masonry after each image loads
  $grid.imagesLoaded().progress( function() {
    $grid.masonry('layout');
  });

});

var slickifyDropdown = function(selector, items) {
  // debugger;
  // if (gon.items !== undefined) {
  //   var itemData = JSON.parse(gon.items)
  // };
  selector.ddslick({
    data: items,
    imagePosition: "left",
    width: 280,
    selectText: "Choose an Item"
  });
}
