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
    var panel = $(this).closest(".panel")
    swal({
      title: 'Are you sure?',
      text: 'This will delete the item. This is irreversable.',
      type: 'warning',
      showCancelButton: true,
      closeOnConfirm: true,
      disableButtonsOnConfirm: true,
      confirmButtonText: "Yes, I'm sure",
      cancelButtonText: "No, cancel!",
      confirmButtonColor: '#f44336'
    }, function(){
      panel.html('<div class="showbox"><div class="loader"><svg class="circular" viewBox="25 25 50 50"><circle class="path" cx="50" cy="50" r="20" fill="none" stroke-width="2" stroke-miterlimit="10"/></svg></div></div>')
      $.ajax({
        url: '/items/' + itemId,
        type: "DELETE"
      });
    });
  });

  $(".delete-button").click(function() {
    var photoId = this.dataset.photoId
    var container = $("#photo-" + photoId)
    swal({
      title: 'Are you sure?',
      text: 'This will delete the photo. This is irreversable.',
      type: 'warning',
      showCancelButton: true,
      closeOnConfirm: true,
      disableButtonsOnConfirm: true,
      confirmButtonText: "Yes, I'm sure",
      cancelButtonText: "No, cancel!",
      confirmButtonColor: '#f44336'
    }, function(){
      container.html('<div class="showbox"><div class="loader"><svg class="circular" viewBox="25 25 50 50"><circle class="path" cx="50" cy="50" r="20" fill="none" stroke-width="2" stroke-miterlimit="10"/></svg></div></div>')
      $.ajax({
        url: '/photos/' + photoId,
        type: "DELETE"
      });
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

  // $("input#item_initial_photos").dropzone();

});

$(".index").ready(function() {
  var $tab = $($("a[role='tab']")[0])
  $tab.tab("show");
})

$(".items.show").ready(function() {
  $('#sale-date').datepicker({
  });
})
