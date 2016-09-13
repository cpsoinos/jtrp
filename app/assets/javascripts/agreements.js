$(document).on('turbolinks:load', function() {
  
  $('.purchase-order-service-charge').bind("ajax:success", function() {
    var serviceChargeWithSymbol = $(this).html();
    var serviceCharge = Number(serviceChargeWithSymbol.replace(/[^0-9\.]+/g,""));
    var subtotal = $(this).data('subtotal');
    var total = subtotal - serviceCharge;
    $("#purchase-order-total").html('$' + total);
    $("#paid-amount-total").html('$' + total);
  });

})
