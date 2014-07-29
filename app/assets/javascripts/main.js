$(document).ready(function(){

  // makes sure they don't use our example email

  if ($('#email-input').val() === "12324857203948572304857230948750923847509283475@example.com"){
    $('#email-input').val('');
  }

  if ($('#show-all-users').length !== 0) {
    GetDated.getScores();
  }

  if ($('#show-user-profile').length !== 0) {
    GetDated.getComparison();
  }

  GetDated.init();

});

GetDated = {

  init: function() {

  },

  getScores: function() {

  },

  getComparison: function() {

  }
};
