$(document).ready(function(){

  // makes sure they don't use our example email
  if ($("#email-input").val() === "12324857203948572304857230948750923847509283475@example.com"){
    $("#email-input").val('');
  }

  GetDated.init();

});

GetDated = {

  init: function() {
    $("#favorite").click(function(event){
      var $target = $("#favorite").data("target");
      var $sender = $("#favorite").data("sender");

      $.ajax({
        url: Routes.favorites_path(),
        type: 'POST',
        dataType: 'json',
        data: {favorite: {fav_initiator:$sender, fav_receiver:$target}}
      })
      .done(function() {
        alert("success");
      })
      .fail(function(data) {
        console.log(data);
      })
      .always(function() {
        console.log("complete");
      });

    });

  }

};
