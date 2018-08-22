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

const forgetOption = (btn) => {
  localStorage[`${btn.name}`] = false;
}

const recordOption = (btn) => {
  localStorage[`${btn.name}`] = true;
}

const unselectOtherOption = (btn) => {
  forgetOption(btn);
  btn.classList.remove("btn-orange-transparent-clicked");
}

const keepButtonClicked = (btn) => {
  btn.classList.add("btn-orange-transparent-clicked");
}

const recordOptionsOnClick = (btnYes, btnNo) => {
  btnYes.addEventListener("click", (e) => {
    recordOption(btnYes);
    keepButtonClicked(btnYes);
    unselectOtherOption(btnNo);
  });
  btnNo.addEventListener("click", (e) => {
    recordOption(btnNo);
    keepButtonClicked(btnNo);
    unselectOtherOption(btnYes);
  });
}

const inputRememberedOptions = (btnYes, btnNo) => {
  if (localStorage['no'] === 'true') {
    keepButtonClicked(btnNo);
  }
  if (localStorage['yes'] === 'true') {
    keepButtonClicked(btnYes);
  }
}

const rememberOptionsBetweenSteps = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const elementPresent  = $("#wrapperSubForm").length;
    if (elementPresent && !validationReturnedError()) {
      const btnYes = document.getElementById("btn-option-yes");
      const btnNo = document.getElementById("btn-option-no");
      inputRememberedOptions(btnYes, btnNo);
      recordOptionsOnClick(btnYes, btnNo);
    };
  });
}

export { rememberOptionsBetweenSteps };
