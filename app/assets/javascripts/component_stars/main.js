var feedback_star = document.getElementById('feedbackStar');

if(feedback_star) {
    $("#feedbackStar").stars(
        {
            stars: 10,
            value: 0,
            click: function(i) {
                $('#feedback_star_input').val(i);
            }
        }
    )
}
