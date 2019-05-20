const enablePopover = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    $(function () {
      $('[data-toggle="popover"]').popover()
    })
  })
}

export {enablePopover}
