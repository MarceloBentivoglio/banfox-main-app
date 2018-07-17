import $ from "jquery";

const infiniteScrolling = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    if ($('#infinite-scrolling')) {
      const loaderPath = "https://res.cloudinary.com/dbzg4txla/image/upload/v1531862798/ajax-loader_e0mexz.gif"
      $(window).on('scroll', function() {
        let more_records_url;
        more_records_url = $('.pagination .next_page').attr('href');
        if (more_records_url && $(window).scrollTop() > $(document).height() - $(window).height() - 1000) {
          document.querySelector('.pagination').innerHTML = `<img src=${loaderPath} alt="Loading..." title="Loading..." />`;
          $.getScript(more_records_url);
        };
      });
    }
  });
}

export { infiniteScrolling };
