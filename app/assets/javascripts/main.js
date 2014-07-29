$(document).ready(function(){

  // makes sure they don't use our example email

  if ($('#email-input').val() === "12324857203948572304857230948750923847509283475@example.com"){
    $('#email-input').val('');
  }

  GetDated.init();

});

GetDated = {
  init: function() {

  }
};
