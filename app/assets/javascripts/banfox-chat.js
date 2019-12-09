function check_chat_api_availability() {
   Rails.ajax({
    url: "/api/v1/check_chat_api_availability",
    type: "get",
    data: "",
    success: function(data) {
      if(data == false){
        document.getElementById("chat-enabler").style.display = "block";
        document.getElementById("chat-disabler").style.display = "none";
      } else if(data == true){
        document.getElementById("chat-enabler").style.display = "none";
        document.getElementById("chat-disabler").style.display = "block";
      }
    },
    error: function(data) {
      console.log(data.statusText)
    }
  })
}
