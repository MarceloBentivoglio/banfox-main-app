import mask from "jquery-mask-plugin";

function maskCpfAndCnpj() {
  $('.cpf').mask('000.000.000-00');
  $('.cnpj').mask('00.000.000/0000-00');
}

export { maskCpfAndCnpj };
