const activateWrapperLoader = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const wrapperLoaderElement = document.getElementById("wrapper-loader");
    const btn = document.getElementById("wrapper-loader-btn");
    if(wrapperLoaderElement) {
      const enableLoaderOnClick = () => {
        btn.addEventListener("click", (e) => {

          form.collapse('show');
        });
      }

    }
  })
}

export {
  enablePopover
}
