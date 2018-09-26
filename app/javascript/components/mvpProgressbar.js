const renderProgressbar = (value, progressbarElement) => {
  progressbarElement.style.width = `${value}%`;
};

const loadProgressbar = (progressbarElement) => {
  const progressbarFinalWidth = Number(progressbarElement.getAttribute("data-value"));
  // To speed up or slow down the navbar complition change the number on the line below.
  const id = setInterval(frame, 50);
  let width = 0;
  function frame() {
    renderProgressbar(width, progressbarElement);
    if (width >= progressbarFinalWidth) {
      clearInterval(id);
    } else {
      width++;
    }
  }
}

const showProgressbar = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const progressbarElement = document.getElementById('mvp-progressbar-fill');
    if (progressbarElement) {
      loadProgressbar(progressbarElement);
    };
  });
};

export { showProgressbar };
