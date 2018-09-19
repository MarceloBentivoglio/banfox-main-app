import $ from 'jquery';

const formatToMoney = (value) => {
  return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value / 100);
}

const operationTotalValuesAccordingToCheck = () => {
  $("[data-installment]").change(() => {
    const installments = $("[data-installment]:checked").toArray().map(el => JSON.parse(el.dataset.installment));
    const total = installments.reduce((sum, installment) => sum + installment.value_cents, 0);
    const fee = installments.reduce((sum, installment) => sum + Number(installment.fee.fractional), 0);
    const net_value = installments.reduce((sum, installment) => sum + Number(installment.net_value.fractional), 0);
    const protection = 0.1 * total;
    const deposit_today = net_value - protection;

    $("#total").text(formatToMoney(total));
    $("#fee").text(formatToMoney(fee));
    $("#protection").text(formatToMoney(protection));
    $("#deposit_today").text(formatToMoney(deposit_today));
    $("#deposit_after").text(formatToMoney(protection));
    $("#net_value").text(formatToMoney(net_value));

  }).trigger("change");
}

export { operationTotalValuesAccordingToCheck }

