$(".jobs.new").on('turbolinks:load', function() {

  if (gon.accounts !== undefined) {
    var accountData = JSON.parse(gon.accounts)
    slickifyDropdown($(".accounts-dropdown"), accountData);
  };


  $("#account-selector-button").click(function() {
    $("#account-selector").toggleClass('hidden');
  });

  $("#job_address_1").geocomplete({
    map: "#job-map",
    details: "form",
    detailsAttribute: "data-geo",
    mapOptions: {
      center: new google.maps.LatLng({lat:42.7516009, lng:-71.2076055})
    }
  });

})

var slickifyDropdown = function(selector, objects) {
  var objectName = $(selector)[0].dataset.className
  selector.ddslick({
    data: objects,
    imagePosition: "left",
    width: '100%',
    selectText: "Select " + objectName,
    onSelected: function(data) {
      if (objectName === "Account") {
        $("#new-account-job-button").html("<a href='/accounts/" + data.selectedData.value + "/jobs/new' class='btn btn-raised btn-primary'>Next</a>");
      } else if (objectName === "Job") {
        $("#job_id")[0].value = (data.selectedData.value);
        $("#new-account-job-proposal-button").toggleClass('hidden');
      }
    }
  });
}
