function show_create_document_button(e){
  if(e.value != ""){
    document.getElementById("sign_button_container").style.display = "block"
  } else {
    document.getElementById("sign_button_container").style.display = "none"
  }
}
