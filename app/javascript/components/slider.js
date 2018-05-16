function sliderShowValue() {
  $(document).ready(() => {
    var slider = document.getElementById("slider");
    if (slider) {
      var output = document.getElementById("slider-value");
      output.innerHTML = slider.value;

      slider.oninput = function() {
        output.innerHTML = "R$ " + this.value + ".000";
      }
    };
  });
}

export { sliderShowValue };

