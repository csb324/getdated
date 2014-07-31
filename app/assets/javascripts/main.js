$(document).ready(function(){

  // makes sure they don't use our example email
  if ($("#email-input").val() === "12324857203948572304857230948750923847509283475@example.com"){
    $("#email-input").val('');
  }

  GetDated.init();

});

GetDated = {

  init: function() {
    // creates a favorite on click!
    $("#favorite").click(function(event){
      event.preventDefault();
      var $target = $("#favorite").data("target");
      var $sender = $("#favorite").data("sender");

      $.ajax({
        url: Routes.favorites_path(),
        type: 'POST',
        dataType: 'json',
        data: {favorite: {fav_initiator:$sender, fav_receiver:$target}}
      })
      .done(function() {
        console.log("success");
        $(".favbutton").empty();
        $(".favbutton").append('<h4>').append("Favorited!");

      })
      .fail(function(data) {
        console.log(data);
      })
      .always(function() {
        console.log("complete");
      });
    });

    $("#message-form").submit(function(event){
      event.preventDefault();
      var $message = $("#message").val();
      if ($message === "") {
        return;
      }
      $("#message").val("");
      var $favid = $("#message-form").data("favorite_id");

      $.ajax({
        url: Routes.messages_path(),
        type: 'POST',
        dataType: 'json',
        data: {message: {msg:$message, favorite_id:$favid}},
      })
      .done(function() {
        $("#messages").append($("<tr>")).append($("<h5>").text($message));
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
