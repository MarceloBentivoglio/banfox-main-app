import $ from 'jquery';

function animateNavbar() {
  $(document).ready(function($) {
    $(window).scroll(function () {
      if ($(this).scrollTop() > 150) {
        $(document.getElementById('logo-banner')).addClass('logo-navbar-dark');
        $(document.getElementById('logo-banner')).removeClass('logo-navbar');
        $(document.getElementById('homenavbar-mvp')).addClass('white-navbar');
      } else {
        $(document.getElementById('logo-banner')).addClass('logo-navbar');
        $(document.getElementById('logo-banner')).removeClass('logo-navbar-dark');
        $(document.getElementById('homenavbar-mvp')).removeClass('white-navbar');
      }
    });
  });
};

export { animateNavbar };
