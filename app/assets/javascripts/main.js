$(document).on('ready page:change', function(){

  // makes sure they don't use our example email
  if ($("#email-input").val() === "12324857203948572304857230948750923847509283475@example.com"){
    $("#email-input").val('');
  }
  console.log("document was ready");
  GetDated.init();
  Effects.dothem();

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

      var $convo = $(".conversation-box");

      $.ajax({
        url: Routes.messages_path(),
        type: 'POST',
        dataType: 'json',
        data: {message: {msg:$message, favorite_id:$favid}},
      })
      .done(function() {
        var $newmessage = $('<div>').addClass("message sent");
        $newmessage.append($('<div>').addClass("message-body").text($message));
        $newmessage.append($('<p>').addClass("message-info").text("Just now"));
        $convo.append($newmessage);
      })
      .fail(function(data) {
        console.log(data);
      })
      .always(function() {
        console.log("complete");
      });
    });

    if($("#message-form").length !== 0){
      var $button = $("#message-form .button");
      var halfHeight = parseInt($button.css("height"))/2;
      $button.attr("style", "border-radius: " + halfHeight + "px;");
    }
  }
};
