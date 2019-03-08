const countdownClock = () => {
  const countdownElement = document.getElementById("countdown-clock");

  if (countdownElement) {
    // Set the time we're counting down to, which is the time the invoice was created plus 3 minutes
    const countDownTime = new Date(countdownElement.getAttribute("data-countdown-time")).getTime() + 60000;
    // The line below is used to test
    // const countDownTime = new Date().getTime() + 180000;

    // Update the count down every 1 second
    let x = setInterval(function () {

      // Get todays date and time
      const now = new Date().getTime();

      // Find the distance between now and the count down date
      const distance = countDownTime - now;

      // Time calculations for days, hours, minutes and seconds
      // let days = Math.floor(distance / (1000 * 60 * 60 * 24));
      // let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      let seconds = Math.floor((distance % (1000 * 60)) / 1000);

      // Output the result in an element with id="countdown-clock"
      countdownElement.innerHTML = minutes + "m " + seconds + "s ";

      // If the count down is over, write some text
      if (distance <= 0) {
        clearInterval(x);
        // countdownElement.innerHTML = "Você será redirecionado";
        window.location.href = "http://localhost:3000/installments/store"
      }
    }, 1000);
  }

};

export { countdownClock };
