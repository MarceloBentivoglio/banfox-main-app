function show_create_document_button(e){
  if(e.value != ""){
    document.getElementById("sign_button_container").style.display = "block"
  } else {
    document.getElementById("sign_button_container").style.display = "none"
  }
}

function show_create_document_button_for_partially_approved(e){
  if(e.value != ""){
    document.getElementById("partially_approved_sign_button_container").style.display = "block"
  } else {
    document.getElementById("partially_approved_sign_button_container").style.display = "none"
  }
}
