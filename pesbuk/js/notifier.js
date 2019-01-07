var elements = [
                {"name": "Notifications", "selector": "a[name='Notifications'] span[data-sigil=count]"}
                ,{"name": "Feeds", "selector": "a[name='News Feed'] span[data-sigil=count]"}
                ,{"name": "Requests", "selector": "a[name='Friend Requests'] span[data-sigil=count]"}
                ,{"name": "Messages", "selector": "a[name='Messages'] span[data-sigil=count]"}
            ]

var targetNode
var elementName
var arrayLength = elements.length;
for (var i = 0; i < arrayLength; i++) {
    elementName = elements[i].name
    targetNode = document.querySelector(elements[i].selector);
    if(targetNode){
        console.log('{"type": "NOTIFY", "push": false, "name": "' + elementName + '", "value": "' + targetNode.innerText + '"}' )
        createObserver(targetNode, elementName)
    }
}


function createObserver(target, targetName){
    var observer = new MutationObserver(function(mutations) {
        //~ console.log("mutation: " + mutation.type + " - " + JSON.stringify(targetName) + " - " + mutation)
        console.log('{"type": "NOTIFY", "push": true, "name": "' + targetName + '", "value": "' + target.innerText + '"}' )
        
        // Commented out to avoid duplicate notifications
        //~ mutations.forEach(function(mutation) {
            //~ if (mutation.type === 'childList') {
                //~ var isNodeChange = false;
                //~ if (mutation.addedNodes.length) {
                    //~ for (var i=0,node;node=mutation.addedNodes[i];i+=1) {
                        //~ if (node.nodeType === 3) {
                            //~ isNodeChange = true;
                            //~ break;
                        //~ }
                    //~ }
                //~ }
                //~ if (mutation.removedNodes.length && !isNodeChange) {
                    //~ for (var i=0,node;node=mutation.removedNodes[i];i+=1) {
                        //~ if (node.nodeType === 3) {
                            //~ isNodeChange = true;
                            //~ break;
                        //~ }
                    //~ }
                //~ }
                
                //~ if(isNodeChange){
                    //~ console.log('{"type": "NOTIFY", "push": true, "name": "' + targetName + '", "value": "' + target.innerText + '"}' )
                //~ }
            //~ }
            
            
          //~ });    
    });
     
    var config = { childList: true };
     
    observer.observe(target, config);
}
