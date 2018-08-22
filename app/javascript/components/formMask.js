import mask from "jquery-mask-plugin";
import SimpleMaskMoney from "simple-mask-money";

const currencyOptions = {
        prefix: '',
        suffix: '',
        fixed: true,
        fractionDigits: 2,
        decimalSeparator: ',',
        thousandsSeparator: '.'
};

const phoneOptions =  {
  onKeyPress: function(phone, e, field, options) {
    console.log(e);
    console.log(phone.length)
    const masks = ['(00) 9 0000-0000', '(00) 0000-0000'];
    let mask = (phone.length>14) ? masks[0] : masks[1];
    if (localStorage['mobile'] == 'true') {mask = masks[0]};
    $('.phone').mask(mask, phoneOptions);
    localStorage['mobile'] = (phone.length < 14) ? false : true;
}};

function maskCpfCnpjCurrency() {
  $('.cpf').mask('000.000.000-00');
  $('.cnpj').mask('00.000.000/0000-00');
  $('.mobile').mask('(00) 9 0000-0000');
  // $('.phone').mask('(00) 0000-0000');
  $('.phone').mask('(00) 0000-0000', phoneOptions);
  $('.birth_date').mask('00/00/0000');
  $('.zip_code').mask('00000-000');
  if (document.getElementById("monthly_revenue")) {
    SimpleMaskMoney.setMask('#monthly_revenue', currencyOptions);
    SimpleMaskMoney.setMask('#monthly_fixed_cost', currencyOptions);
    SimpleMaskMoney.setMask('#cost_per_unit', currencyOptions);
    SimpleMaskMoney.setMask('#debt', currencyOptions);
  }
  $("#monthly_revenue").mask("#.##0,00", {reverse: true, maxlength: false});
  $("#monthly_fixed_cost").mask("#.##0,00", {reverse: true, maxlength: false});
  $("#cost_per_unit").mask("#.##0,00", {reverse: true, maxlength: false});
  $("#debt").mask("#.##0,00", {reverse: true, maxlength: false});
}

export { maskCpfCnpjCurrency };
