var elements = [
                {"name": "Notifications", "selector": "a[name='Notifications'] span[data-sigil=count]"}
                ,{"name": "Feeds", "selector": "a[name='News Feed'] span[data-sigil=count]"}
                ,{"name": "Requests", "selector": "a[name='Friend Requests'] span[data-sigil=count]"}
                ,{"name": "Messages", "selector": "a[name='Messages'] span[data-sigil=count]"}
            ]

var targetNode
var arrayLength = elements.length;
for (var i = 0; i < arrayLength; i++) {
    targetNode = document.querySelector(elements[i].selector);
    if(targetNode){
        console.log('{"type": "NOTIFY", "name": "' + elements[i].name + '", "value": "' + targetNode.innerText + '"}' )
        createObserver(targetNode)
    }
}


function createObserver(target){
    // create an observer instance
    var observer = new MutationObserver(function(mutations) {
      mutations.forEach(function(mutation) {
        console.log("mutation type: " + mutation.type)
        console.log("mutation after Text: " + target.innerText)
      });    
    });
     
    // configuration of the observer:
    var config = { attributes: true, childList: true, characterData: true };
     
    // pass in the target node, as well as the observer options
    observer.observe(target, config);
}
