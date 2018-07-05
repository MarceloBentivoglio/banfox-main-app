import fadeTo from "jquery";
import slideUp from "jquery";
import $ from "jquery";

const presentAndDismissAlerts = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    $(".alert").fadeTo(8000, 1).slideUp(2000, function(){
      $(".alert").slideUp(500);
    });
  });
}

export { presentAndDismissAlerts };
