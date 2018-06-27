// TODO: refatorar
function sliderShowValue() {
  $(document).ready(() => {
    const slider = document.getElementById("revenue");
    const slider2 = document.getElementById("rental_cost");
    const slider3 = document.getElementById("employees");
    if (slider) {
      var output = document.getElementById("revenue-slider-value");
      output.innerHTML = slider.value;
      output.innerHTML = "R$ " + slider.value + ".000";
      slider.oninput = function() {
        output.innerHTML = "R$ " + this.value + ".000";
      }
    };
    if (slider2) {
      var output2 = document.getElementById("rental_cost-slider-value");
      output2.innerHTML = slider2.value;
      output2.innerHTML = "R$ " + slider2.value + ".000";
      slider2.oninput = function() {
        output2.innerHTML = "R$ " + this.value + ".000";
      }
    };
    if (slider3) {
      var output3 = document.getElementById("employees-slider-value");
      output3.innerHTML = slider3.value;
      output3.innerHTML = slider3.value + " funcionários";
      slider3.oninput = function() {
        output3.innerHTML = this.value + " funcionários";
      }
    };
  });
}

export { sliderShowValue };
