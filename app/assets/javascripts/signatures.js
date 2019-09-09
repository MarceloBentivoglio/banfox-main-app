function start_d4sign_debtors() {
  key_signer = document.getElementById("signature-div").getAttribute("data-signature-key");
  email = document.getElementById("signature-div").getAttribute("data-email");
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
    width: '1025',
    height: '400',
    callback: function(event) {
      if (event.data === "signed") {
        window.location.replace(redirection_url);
      }
    }
  });
}
