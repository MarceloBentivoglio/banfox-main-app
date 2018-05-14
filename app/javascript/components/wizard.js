function selectTagOnClick() {
  $(document).ready(() => {
    $(".tag-choice").click(function(){
      $(this).toggleClass("active");
    });
  });
}

export { selectTagOnClick };

