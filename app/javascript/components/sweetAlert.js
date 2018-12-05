import swal from 'sweetalert';

function bindSweetAlertButton() {
  const swalButton = document.getElementById('sweet-alert-button');
  if (swalButton) { // protect other pages
    swalButton.addEventListener('click', () => {
      swal({
        title: "Seu contrato está assinado",
        text: "Seu dinheiro já está a caminho",
        icon: "success"
      });
    });
  }
}

export { bindSweetAlertButton };
