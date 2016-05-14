$(".agreements.index").ready(function() {
  var $tab = $($("a[role='tab'")[0])
  $tab.tab("show")

  handleSignatures();
})

var handleSignatures = function() {
  var options = {
    drawOnly: true
  }
  var signatures = gon.signatures

  for (i in signatures) {
    agreement = signatures[parseInt(i)]
    var managerSelector = '#' + agreement.agreement_type + '-manager-signed'
    var clientSelector = '#' + agreement.agreement_type + '-client-signed'

    if(agreement.manager_signature === null) {
      $(managerSelector).signaturePad(options)
    } else {
      fillSignatures(managerSelector, agreement.manager_signature)
    };

    if(agreement.client_signature === null) {
      $(clientSelector).signaturePad(options)
    } else {
      fillSignatures(clientSelector, agreement.client_signature)
    };
  }

}

var fillSignatures = function(selector, sig) {
  $(selector).signaturePad({displayOnly:true}).regenerate(sig);
}
