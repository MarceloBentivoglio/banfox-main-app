// TODO: refatorar
function sliderShowValue() {
  $(document).ready(() => {
    var slider = document.getElementById("revenue");
    var slider2 = document.getElementById("rental_cost");
    var slider3 = document.getElementById("employees");
    if (slider) {
      var output = document.getElementById("revenue-slider-value");
      output.innerHTML = slider.value;
      slider.oninput = function() {
        output.innerHTML = "R$ " + this.value + ".000";
      }
    };
    if (slider2) {
      var output2 = document.getElementById("rental_cost-slider-value");
      output2.innerHTML = slider2.value;
      slider2.oninput = function() {
        output2.innerHTML = "R$ " + this.value + ".000";
      }
    };
    if (slider3) {
      var output3 = document.getElementById("employees-slider-value");
      output3.innerHTML = slider3.value;
      slider3.oninput = function() {
        output3.innerHTML = this.value;
      }
    };
  });
}

export { sliderShowValue };

