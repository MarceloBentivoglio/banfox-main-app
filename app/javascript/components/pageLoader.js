const loopCheckContextProcessed = (processed, pollingUrl, wrapperLoaderElement) => {
  if(processed) {
    window.location.reload();
  } else {
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
      loopCheckContextProcessed(data.processed, pollingUrl, wrapperLoaderElement);
    }
  })
}

const activatePageLoader = () => {
  document.addEventListener("DOMContentLoaded", (event) => {
    const wrapperLoaderElement = document.getElementById("wrapper-loader");
    const wrappedPage = document.getElementById("wrapped-page");

    if(wrappedPage) {
      wrapperLoaderElement.style.display = "block";
      const pollingUrl = wrappedPage.attributes["polling-url"].value;
      pollCheckContextProcessed(pollingUrl, wrapperLoaderElement);
    }
  })
}

export { activatePageLoader };
