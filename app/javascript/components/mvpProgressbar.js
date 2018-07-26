const renderProgressbar = (value, progressbarElement) => {
  progressbarElement.style.width = `${value}%`;
};

const loadProgressbar = (progressbarElement) => {
  const t = setTimeout(() => {
    renderProgressbar(t, progressbarElement)
    loadProgressbar(progressbarElement);
  }, 30);
  if (t == progressbarElement.getAttribute("data-value")) { clearTimeout(t); }
  console.log(t);
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
