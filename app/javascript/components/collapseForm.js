import $ from 'jquery';
import collapse from 'bootstrap';

const validationReturnedError = () => {
  const arr = Array.from(document.getElementsByClassName("invalid-feedback"));
  let flag = false;
  arr.forEach((elem) => {
    if (elem.innerHTML) {
      flag = true;
    };
  });
  return flag;
}

const cleanForm = () => {
  $("#seller_full_name_partner").val('');
  $("#seller_cpf_partner").val('');
  $("#seller_birth_date_partner").val('');
  $("#seller_email_partner").val('');
  $("#seller_mobile_partner").val('');
}

const reInputForm = () => {
  $("#seller_full_name_partner").val(localStorage['fullName']);
  $("#seller_cpf_partner").val(localStorage['cpf']);
  $("#seller_birth_date_partner").val(localStorage['birthDate']);
  $("#seller_email_partner").val(localStorage['email']);
  $("#seller_mobile_partner").val(localStorage['mobile']);
}

const storeForm = () => {
  localStorage['fullName'] = localStorage['fullName'] || $("#seller_full_name_partner").val();
  localStorage['cpf'] = localStorage['cpf'] || $("#seller_cpf_partner").val();
  localStorage['birthDate'] = localStorage['birthDate'] || $("#seller_birth_date_partner").val();
  localStorage['email'] = localStorage['email'] || $("#seller_email_partner").val();
  localStorage['mobile'] = localStorage['mobile'] || $("#seller_mobile_partner").val();
}

const keepFormOpened = (form) => {
  form.collapse('show')
}

const keepButtonClicked = (btn) => {
  btn.classList.add("btn-orange-transparent-clicked");
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

const configCollapse = () => {
  const subForm = $("#wrapperSubForm");
  const no = document.getElementById("btn-option-no");
  const yes = document.getElementById("btn-option-yes");
  storeForm()
  if (localStorage['no'] == 'true') {
    keepFormOpened(subForm);
  }
  if (validationReturnedError()) {
    keepButtonClicked(no);
    yes.addEventListener('click', (e) => {
      e.preventDefault();
      e.currentTarget.classList.remove('btn-orange-transparent');
      e.currentTarget.classList.add('btn-orange-transparent-inactive');
    })
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
