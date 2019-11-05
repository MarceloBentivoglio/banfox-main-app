import $ from 'jquery';
import 'webpack-jquery-ui';

const consentModal = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const consentModalDiv = document.getElementById('modal-consent');
    if (consentModalDiv) {
      $("#showModalConsent").click(function(e) {
        e.preventDefault();
        $("#modal-consent").modal('show');
      })
    };
  });
};



export { consentModal }
