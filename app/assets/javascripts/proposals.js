$(".proposals.consignment_agreement").ready(function() {
  handleSignatures();
})

var handleSignatures = function() {
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

var fillSignatures = function(selector, sig) {
  $(('#' + selector + '-signed') ).signaturePad({displayOnly:true}).regenerate(sig);
}
