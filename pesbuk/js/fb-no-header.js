var noHeaderCSS;

toggleHeader = function (show) {
    if (show) {
        if (noHeaderCSS) {
            document.head.removeChild(noHeaderCSS);
        }
    } else {
        var header = document.querySelector("div#header[data-sigil=MTopBlueBarHeader]");
        var topMargin = 0

        noHeaderCSS = document.createElement("style");
        noHeaderCSS.type = "text/css";
        noHeaderCSS.id = "noHeader";
        
        noHeaderCSS.innerText  = "div#header[data-sigil=MTopBlueBarHeader], div#header {z-index: 1}"
        noHeaderCSS.innerText += "div#header[data-sigil=MTopBlueBarHeader] div#bookmarks_flyout{margin: 0px}"

        if(header){
            topMargin = header.offsetHeight
            noHeaderCSS.innerText += "div#rootcontainer{top: -44px; position: relative; z-index: 2}"
        }
        
        document.head.appendChild(noHeaderCSS);
    }
}


