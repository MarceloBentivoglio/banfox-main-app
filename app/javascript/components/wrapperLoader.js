const activateWrapperLoaderOnClick = (btn, wrapperLoaderElement) => {
  btn.addEventListener("click", (e) => {
    wrapperLoaderElement.style.display = "block";
  });
}

const activateWrapperLoader = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const wrapperLoaderElement = document.getElementById("wrapper-loader");
    const btn = document.getElementById("wrapper-loader-trigger");
    if(wrapperLoaderElement) {
      activateWrapperLoaderOnClick(btn, wrapperLoaderElement);
    }
  })
}

export { activateWrapperLoader };
