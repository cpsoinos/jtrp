$(".agreements").ready(function() {

  var $tab = $($("a[role='tab']")[0])
  $tab.tab("show");

  $('.purchase-order-service-charge').bind("ajax:success", function() {
    var serviceChargeWithSymbol = $(this).html();
    var serviceCharge = Number(serviceChargeWithSymbol.replace(/[^0-9\.]+/g,""));
    var subtotal = $(this).data('subtotal');
    var total = subtotal - serviceCharge;
    $("#purchase-order-total").html('$' + total);
    $("#paid-amount-total").html('$' + total);
  });

})
