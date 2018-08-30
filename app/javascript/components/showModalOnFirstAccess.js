import $ from 'jquery';

const showModalOnFirstAccess = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const createAppointmentElement = document.getElementById('modal-create-appointment');
    if (createAppointmentElement) {
      $("#modal-create-appointment").modal('show');
    };
  });
};

export { showModalOnFirstAccess }
