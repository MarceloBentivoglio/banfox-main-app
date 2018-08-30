import $ from 'jquery';

const showModalOnFirstAccess = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const createAppointmentElement = document.getElementById('modal-show-wo-click-present');
    if (createAppointmentElement) {
      $("#modal-show-wo-click").modal('show');
    };
  });
};

export { showModalOnFirstAccess }
