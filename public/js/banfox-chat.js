function get_chat_room() {
  $.ajax({
    url: "/api/v1/get_chat_room",
    type: "get",
    data: "",
    success: function(data) {
      sessionStorage.session_id = data.session_id;
      sessionStorage.code = data.code;
      sessionStorage.first = true;
      document.getElementById("first_moment").innerHTML = data.created_at;
      document.getElementById("chat-container").style.display = "block";
    },
    error: function(data) {
      console.log(data.statusText)
    }
  })
}

function enable_submit(e) {
  if(e.value == "") {
    document.getElementById("chat_button").disabled = true;
  } else {
    document.getElementById("chat_button").disabled = false;
  }
}

function send_message() {
  var data_to_send = {};
  data_to_send.message = document.getElementById("chat_input").value;
  data_to_send.session_id = sessionStorage.session_id;
  data_to_send.room_code = sessionStorage.code;
  data_to_send.first = sessionStorage.first;
  sessionStorage.first = false;

  $.ajax({
    url: "/api/v1/send_message",
    type: "post",
    data: data_to_send,
    success: function(data) {
      var html_block = "";

      html_block += "<div class='chat_container client_side'>";
      html_block += "<div class='timestamp'>";
      html_block += "<small>" + data.created_at + "</small>";
      html_block += "</div>";
      html_block += "<div class='message'>";
      html_block += data.body;
      html_block += "</div>";
      html_block += "</div>";

      $("#chat_window").append(html_block);
      document.getElementById("chat_input").value = ""
      document.getElementById("chat_input").focus();
      scroll_to_last_message();
    },
    error: function(data){
      console.log(data.statusText);
      var html_block = "";

      html_block += "<div class='chat_container client_side'>";
      html_block += "<div class='timestamp'>";
      html_block += "<small>13:02:11</small>";
      html_block += "</div>";
      html_block += "<div class='message'>";
      html_block += "Mensagem não pode ser enviada. Por favor tente novamente";
      html_block += "</div>";
      html_block += "</div>";

      $("#chat_window").append(html_block);
      document.getElementById("chat_input").focus();
      scroll_to_last_message();
    }
  })
}

function scroll_to_last_message() {
  var chat_div = document.getElementById("chat_window");

  chat_div.scrollTop = chat_div.scrollHeight;
}
