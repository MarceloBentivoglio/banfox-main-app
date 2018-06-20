const displayFileNames = (event) => {
  const input = event.target;
  const infoArea = event.target.parentNode.parentNode.querySelector(".file-status");
  let txt = "";
  if ('files' in input) {
      if (input.files.length === 0) {
          txt = "Selecione um ou mais arquivos";
      } else {
          for (let i = 0; i < input.files.length; i++) {
              txt += "<li><strong>" + (i+1) + ". </strong>";
              let file = input.files[i];
              if ('name' in file) {
                  txt += "<strong>" + file.name + "</strong>";
              }
              if ('size' in file) {
                  txt += " | " + file.size + " bytes </li>";
              }
          }
      }
  } else {
    if (input.value === "") {
        txt += "Selecione um ou mais arquivos";
    } else {
        txt += "Este tipo de arquivo não é suportado pelo seu navegador! Favor usar o Chrome!";
        txt  += "<br>Informe este código para a MVP: " + input.value;
    }
  }
  infoArea.innerHTML = txt;
};

const bindDisplayFileName = (element) => {
  element.addEventListener("change", displayFileNames);
};

const nameFilesToUpload = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    event.target.querySelectorAll(".inputfile").forEach(bindDisplayFileName);
  });
};

export { nameFilesToUpload };
