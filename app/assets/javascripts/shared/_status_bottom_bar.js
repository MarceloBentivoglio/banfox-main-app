function disable_button(e){
  e.style.display = "none"
  document.getElementById("action-on-process-button").style.display = "block"
}

function check_sign_document_status(operation_id, redirect_url) {
  var redirect_url = document.getElementById("sign-document-redirect-url").value
  var operation_id = document.getElementById("current-operation-id").value

  Rails.ajax({
    url: "/check_sign_document_status/" + operation_id,
    type: "get",
    data: "",
    success: function(data) {
      if(data == "completed"){
        location.replace(redirect_url)
      }
    },
    error: function(data) {
      console.log(data)
    }
  })
}
