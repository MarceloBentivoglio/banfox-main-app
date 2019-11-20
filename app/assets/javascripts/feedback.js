var recommend_banfox = document.getElementById('recommend_banfox');

if(recommend_banfox) {
    $(".recommend_banfox_yes").click(function(e) {
        e.preventDefault();

        $("#recommend_banfox").val(1)
        $('.recommend_banfox_option').removeClass("selectedRecommendation");
        $(this).addClass("selectedRecommendation");
    })

    $(".recommend_banfox_no").click(function(e) {
        e.preventDefault();

        $("#recommend_banfox").val(0);
        $('.recommend_banfox_option').removeClass("selectedRecommendation");
        $(this).addClass("selectedRecommendation");
    })

}
