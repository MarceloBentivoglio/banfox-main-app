const enableTooltip = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    $(function () {
      $('[data-toggle="tooltip"]').tooltip()
    })
  })
}

export {
  enableTooltip
}
