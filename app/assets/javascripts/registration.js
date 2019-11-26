function check_if_mobile() {
  if (/Mobi|Android/i.test(navigator.userAgent)) {
    document.getElementById("mobile_page").style.display = "block"
    document.getElementById("desktop_page").style.display = "none"
  } else {
    document.getElementById("mobile_page").style.display = "none"
    document.getElementById("desktop_page").style.display = "block"
  }
}
