import $ from "jquery";

const infiniteScrolling = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    if ($('#infinite-scrolling')) {
      const loaderPath = "https://res.cloudinary.com/dbzg4txla/image/upload/v1531862798/ajax-loader_e0mexz.gif"
      $(window).on('scroll', function() {
        const next_page_url = $('.pagination .next_page').attr('href');
        if (next_page_url && $(window).scrollTop() > $(document).height() - $(window).height() - 1000) {
          document.querySelector('.pagination').innerHTML = `<img src=${loaderPath} alt="Loading..." title="Loading..." />`;
          $.getScript(next_page_url);
        };
      });
    }
  });
}

export { infiniteScrolling };
