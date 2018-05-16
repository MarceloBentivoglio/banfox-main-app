function selectTagOnClick() {
  $(document).ready(() => {
    $(".tag-choice.single-choice").click(function(){
      $(".tag-choice.single-choice").removeClass("active");
    });

    $(".tag-choice").click(function(){
      $(this).toggleClass("active");
    });
  });

}

export { selectTagOnClick };
