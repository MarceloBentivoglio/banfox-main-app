function start_d4sign() {
  key_signer = document.getElementById("signature-div").getAttribute("data-signature-key");
  email = document.getElementById("signature-div").getAttribute("data-partner-email");
  redirection_url = document.getElementById("signature-div").getAttribute("data-redirection-url");
  doc_uuid = document.getElementById("signature-div").getAttribute("data-document-uuid");
  d4sign.configure({
    container: "signature-div",
    key: doc_uuid,
    protocol: "https",
    host: "secure.d4sign.com.br/embed/viewblob",
    signer: {
      email: email,
      key_signer: key_signer
    },
    width: '100%',
    height: '400',
    callback: function(event) {
      if (event.data === "signed") {
        document.getElementById("signature-container").style.display = "none"
        document.getElementById("countdown-container").style.display = "block"
        var counter = 5;
        var interval = setInterval(function() {
          counter--;
          document.getElementById("countdown").innerText = counter + "s";
          if (counter == 0) {
            clearInterval(interval);
            setTimeout(function(){
              window.location.replace(redirection_url);
            }, 1000)
          }
        }, 1000);
      }
    }
  });
}
