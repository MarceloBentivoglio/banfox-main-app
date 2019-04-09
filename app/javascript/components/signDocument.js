function Clicksign(o) {
  "use strict";
  var r, u, t = window.location.protocol + "//" + window.location.host,
    e = {},
    n = function (t) {
      (e[t] || []).forEach(function (t) {
        t()
      })
    },
    c = function (t) {
      n(t.data)
    };
  return {
    endpoint: "https://app.clicksign.com",
    origin: t,
    mount: function (t) {
      var n = "/sign/" + o,
        e = "?embedded=true&origin=" + this.origin,
        i = this.endpoint + n + e;
      return u = document.getElementById(t), (r = document.createElement("iframe")).setAttribute("src", i), r.setAttribute("style", "width: 100%; height: 100%;"), window.addEventListener("message", c), u.appendChild(r)
    },
    unmount: function () {
      return r && (u.removeChild(r), r = u = null, window.removeEventListener("message", n)), !0
    },
    on: function (t, n) {
      return e[t] || (e[t] = []), e[t].push(n)
    },
    trigger: n
  }
}

const signDocument = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const documentContainer = document.getElementById('document-container');
    if (documentContainer) {
      const signatureKey = documentContainer.getAttribute('data-signature-key')
      // Carrega o widget embedded com a request_signature_key
      let widget = new Clicksign(signatureKey);
      // Define o endpoint https://sandbox.clicksign.com ou https://app.clicksign.com
      widget.endpoint = 'https://sandbox.clicksign.com';

      // Define a URL de origem (parametro necessário para utilizar através de WebView)
      widget.origin = 'https://2c78364b.ngrok.io/operations/sign_document';

      // Monta o widget no div
      widget.mount('document-container');

      //Callback que será disparado quando o documento for carregado
      widget.on('loaded', function (ev) {
        console.log('loaded!');
      });

      //Callback que será disparado quando o documento for assinado
      const redirectionUrl = documentContainer.getAttribute("data-redirection-url");
      widget.on('signed', function (ev) {
        console.log('signed!');
        window.location.href = redirectionUrl;
        return location.assign(redirectionUrl);
      });
    };
  });
};

export { signDocument };





