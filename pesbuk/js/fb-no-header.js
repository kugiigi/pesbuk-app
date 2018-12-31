
//~ var header = document.querySelector("div#header[data-sigil=MTopBlueBarHeader]");
//~ if (header) {
    //~ header.style.display = "none";
    //~ header.style.height = 0;
    //~ header.style.opacity = 0;
//~ }

//~ var backHeader = document.querySelector("div#MBackNavBar");
//~ if (backHeader) {
    //~ backHeader.style.display = "none";
//~ }

var header = document.querySelector("div#header[data-sigil=MTopBlueBarHeader]");
var topMargin = 0

css = document.createElement("style");
css.type = "text/css";
css.id = "noHeader";
document.head.appendChild(css);
css.innerText  = "div#header[data-sigil=MTopBlueBarHeader], div#header {z-index: 1}"
//~ css.innerText += "div#header{z-index: 1}"
css.innerText += "div#header[data-sigil=MTopBlueBarHeader] div#bookmarks_flyout{margin: 0px}"
//~ css.innerText += "div#rootcontainer{top: -" + topMargin + "px; position: relative; z-index: 2}"

if(header){
    topMargin = header.offsetHeight
    console.log("topMargin: " + topMargin)
    css.innerText += "div#rootcontainer{top: -44px; position: relative; z-index: 2}"
}


