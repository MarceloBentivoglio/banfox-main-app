import $ from 'jquery';

const formatToMoney = (value) => {
  return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(formatToNumber(value) / 100);
}

const formatToNumber = (value) => {
  return Number(value.toString().replace(/[^0-9\-]+/g,""));
}

const showTotalsOnStatusBar = (total, fee, credit, total_with_credit, net_value) => {
    $("#total").text(formatToMoney(total));
    $("#fee").text(formatToMoney(fee));
    $("#credit").text(formatToMoney(credit));
    $("#total_with_credit").text(formatToMoney(total_with_credit));
    $("#credit_to_sum").text(formatToMoney(credit));
    $("#net_value").text(formatToMoney(net_value));
}

const operationTotalValuesAccordingToCheck = () => {
  $("[data-installment]").change((event) => {
    const credit = $('#credit').data('credit').replace(",","");
    const installments = $("[data-installment]:checked").toArray().map(el => JSON.parse(el.dataset.installment));
    const total = installments.reduce((sum, installment) => sum + installment.value_cents, 0);
    const fee = installments.reduce((sum, installment) => sum + -1*Number(installment.fee.fractional), 0);
    const net_value = installments.reduce((sum, installment) => sum + Number(installment.net_value.fractional), 0);
    const total_with_credit = net_value + Number(credit);
    showTotalsOnStatusBar(total, fee, credit, total_with_credit, net_value);
  }).trigger("change");
}

const operationInAnalysisTotalValues = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    if (document.getElementById("status_bottom_bar") && (document.querySelectorAll('[data-installment]').length === 0)) {
      const credit = $('#credit').data('credit').replace(",","");
      const total = $(".installment_value").toArray().reduce((sum, installment) => sum + formatToNumber(installment.textContent), 0);
      const fee = $(".fee").toArray().reduce((sum, installment) => sum + -1*formatToNumber(installment.textContent), 0);
      const net_value = $(".net_value").toArray().reduce((sum, installment) => sum + formatToNumber(installment.textContent), 0);
      const total_with_credit = net_value + Number(credit);
      showTotalsOnStatusBar(total, fee, credit, total_with_credit, net_value);
    }
  });
}

export { operationTotalValuesAccordingToCheck }
export { operationInAnalysisTotalValues }

