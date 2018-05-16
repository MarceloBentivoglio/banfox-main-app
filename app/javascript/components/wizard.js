function selectTagOnClick() {
  $(document).ready(() => {
    $(".tag-choice.single-choice").click(function(){
      $(".tag-choice.single-choice").removeClass("active");
    });

    $(".tag-choice").click(function(){
      $(this).toggleClass("active");
    });

    var slider = document.getElementById("seller_revenue");
    var output = document.getElementById("slider-value");
    output.innerHTML = slider.value;

    slider.oninput = function() {
      output.innerHTML = "R$ " + this.value + ".000";
    }

  });

}

export { selectTagOnClick };
