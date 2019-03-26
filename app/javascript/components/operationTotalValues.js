import $ from 'jquery';

const formatToMoney = (value) => {
  return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value / 100);
}

const formatToNumber = (valueInString) => {
  return Number(valueInString.replace(/[^0-9]+/g,""));
}

const showTotalsOnStatusBar = (total, fee, protection, deposit_today, net_value) => {
    $("#total").text(formatToMoney(total));
    $("#fee").text(formatToMoney(fee));
    $("#protection").text(formatToMoney(protection));
    $("#deposit_today").text(formatToMoney(deposit_today));
    $("#deposit_after").text(formatToMoney(protection));
    $("#net_value").text(formatToMoney(net_value));
}

const operationTotalValuesAccordingToCheck = () => {
  // $( "[data-installment]" ).on( "click", function(event) {
  //   event.preventDefault();
  //   console.log( $( this ).toArray().map(el => JSON.parse(el.dataset.installment))[0]["value_cents"] );
  //   console.log( $( this ));
  //   console.log( event);
  // });
  $("[data-installment]").change((event) => {
    // console.log( event);
    const protectionRate = $('#protection').data('protection');
    const installments = $("[data-installment]:checked").toArray().map(el => JSON.parse(el.dataset.installment));
    const total = installments.reduce((sum, installment) => sum + installment.value_cents, 0);
    const fee = installments.reduce((sum, installment) => sum + Number(installment.fee.fractional), 0);
    const net_value = installments.reduce((sum, installment) => sum + Number(installment.net_value.fractional), 0);
    const protection = protectionRate * total;
    const deposit_today = net_value - protection;
    showTotalsOnStatusBar(total, fee, protection, deposit_today, net_value);
  }).trigger("change");
}

const operationInAnalysisTotalValues = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    if (document.getElementById("status_bottom_bar") && (document.querySelectorAll('[data-installment]').length === 0)) {
      const protectionRate = $('#protection').data('protection');
      const total = $(".installment_value").toArray().reduce((sum, installment) => sum + formatToNumber(installment.textContent), 0);
      const fee = $(".fee").toArray().reduce((sum, installment) => sum + formatToNumber(installment.textContent), 0);
      const net_value = $(".net_value").toArray().reduce((sum, installment) => sum + formatToNumber(installment.textContent), 0);
      const protection = protectionRate * total;
      const deposit_today = net_value - protection;
      showTotalsOnStatusBar(total, fee, protection, deposit_today, net_value);
    }
  });
}

export { operationTotalValuesAccordingToCheck }
export { operationInAnalysisTotalValues }

