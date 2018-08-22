import $ from 'jquery';
import collapse from 'bootstrap';

const cleanForm = () => {
  $("#seller_full_name_partner").val('');
  $("#seller_cpf_partner").val('');
  $("#seller_birth_date_partner").val('');
  $("#seller_email_partner").val('');
  $("#seller_mobile_partner").val('');
}

const reInputForm = () => {
  if (!$("#seller_full_name_partner").val()) {$("#seller_full_name_partner").val(localStorage['fullName'])};
  if (!$("#seller_cpf_partner").val()) {$("#seller_cpf_partner").val(localStorage['cpf'])};
  if (!$("#seller_birth_date_partner").val()) {$("#seller_birth_date_partner").val(localStorage['birthDate'])};
  if (!$("#seller_email_partner").val()) {$("#seller_email_partner").val(localStorage['email'])};
  if (!$("#seller_mobile_partner").val()) {$("#seller_mobile_partner").val(localStorage['mobile'])};
}

const storeForm = () => {
  localStorage['fullName'] = $("#seller_full_name_partner").val();
  localStorage['cpf'] = $("#seller_cpf_partner").val();
  localStorage['birthDate'] = $("#seller_birthDate_partner").val();
  localStorage['email'] = $("#seller_email_partner").val();
  localStorage['mobile'] = $("#seller_mobile_partner").val();
}

const keepFormOpened = (form) => {
  form.collapse('show')
}

const openFormOnClick = (btn, form) => {
  btn.addEventListener("click", (e) => {
    e.preventDefault();
    cleanForm();
    form.collapse('show');
  });
}

const closeFormOnClick = (btn, form) => {
  btn.addEventListener("click", (e) => {
    e.preventDefault();
    form.collapse('hide');
    reInputForm();
  });
}

const collapseFormOnOptionButton = (openBtn, closeBtn, form) => {
  openFormOnClick(openBtn, form);
  closeFormOnClick(closeBtn, form);
}

const afterValidation = () => {
  const arr = Array.from(document.getElementsByClassName("invalid-feedback"));
  let flag = false;
  arr.forEach((elem) => {
    if (elem.innerHTML) {
      flag = true;
    };
  });
  return flag;
}

const keepButtonClicked = (btn) => {
  btn.classList.add("btn-orange-transparent-clicked");
}

const configCollapse = () => {
  const subForm = $("#wrapperSubForm");
  const no = document.getElementById("btn-option-no");
  const yes = document.getElementById("btn-option-yes");
  storeForm()
  if (afterValidation()) {
    keepButtonClicked(no);
    keepFormOpened(subForm);
  } else {
    collapseFormOnOptionButton(no, yes, subForm);
  };
}

const collapseForm = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const elementPresent  = $("#wrapperSubForm").length;
    if (elementPresent) { configCollapse() }
  });
}

export { collapseForm };
