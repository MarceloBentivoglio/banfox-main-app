const loopCheckContextProcessed = (processed, pollingUrl, wrapperLoaderElement) => {
  if(processed) {
    wrapperLoaderElement.style.display = "block";
  } else {
    console.log("Not processed yet... sleeping")
    setTimeout(() => {
      pollCheckContextProcessed(pollingUrl, wrapperLoaderElement);
    }, 3000);
  }
}

const pollCheckContextProcessed = (pollingUrl, wrapperLoaderElement) => {
  Rails.ajax({
    url: pollingUrl,
    type: "get",
    dataType: 'json',
    data: "",
    success: function(data) {
      debugger;
      loopCheckContextProcessed(data.processed, pollingUrl, wrapperLoaderElement);
    }
  })
}

const activatePageLoader = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const wrapperLoaderElement = document.getElementById("wrapper-loader");
    const wrappedPage = document.getElementById("wrapped-page");
    const pollingUrl = wrappedPage.attributes["polling-url"].value;

    wrapperLoaderElement.style.display = "block";

    if(wrappedPage) {
      pollCheckContextProcessed(pollingUrl, wrapperLoaderElement);
    }
  })
}

export { activatePageLoader };
