function selectTagOnClick() {
  $(document).ready(() => {
    $(".tag-choice").click(function(){
      $(".tag-choice.single-choice").removeClass("active");
      $(this).toggleClass("active");
    });
  });
}

export { selectTagOnClick };
