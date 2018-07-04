document.body.className += " js-loading";

window.addEventListener("load", showPage, false);

function showPage() {
  document.body.className = document.body.className.replace("js-loading","");
}

export { showPage };
