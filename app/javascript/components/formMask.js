import mask from "jquery-mask-plugin";
import SimpleMaskMoney from "simple-mask-money";

const currencyOptions = {
        prefix: '',
        suffix: '',
        fixed: true,
        fractionDigits: 2,
        decimalSeparator: ',',
        thousandsSeparator: '.',
        reverse: true,
        mask: '#.##0,00'
};

function maskCpfCnpjCurrency() {
  $('.cpf').mask('000.000.000-00');
  $('.cnpj').mask('00.000.000/0000-00');
  $('.mobile').mask('(00) 9 0000-0000');
  $('.phone').mask('(00) 000000000');
  $('.birth_date').mask('00/00/0000');
  $('.zip_code').mask('00000-000');
  if (document.getElementById("monthly_revenue")) {
   SimpleMaskMoney.setMask('#monthly_revenue', currencyOptions);
   SimpleMaskMoney.setMask('#monthly_fixed_cost', currencyOptions);
   SimpleMaskMoney.setMask('#cost_per_unit', currencyOptions);
   SimpleMaskMoney.setMask('#debt', currencyOptions);

   if(document.getElementsByClassName('is-invalid').length == 0) {
     let elements = document.getElementsByClassName('is-valid'),
     elements_number = elements.length;

     for(let i = 0; i < elements_number; i++) {
       elements[0].classList.remove('is-valid');
     }
   }
  }
}

export { maskCpfCnpjCurrency };
