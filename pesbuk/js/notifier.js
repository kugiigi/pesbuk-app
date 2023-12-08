var elements = [
                {"name": "Notifications", "selector": "div.m[data-comp-id='7'] div.native-text span.f6"}
                ,{"name": "Feeds", "selector": "div.m[data-comp-id='1'] div.native-text span.f6"}
                ,{"name": "Requests", "selector": "div.m[data-comp-id='4'] div.native-text span.f6"}
                ,{"name": "Messages", "selector": "div.m[data-comp-id='5'] div.native-text span.f6"}
            ]

var targetNode
var elementName
var arrayLength = elements.length;
for (var i = 0; i < arrayLength; i++) {
    elementName = elements[i].name
    targetNode = document.querySelector(elements[i].selector);
    if(targetNode){
        let _countNumber = targetNode.innerText
        _countNumber = parseFloat(_countNumber) ? _countNumber : 0
        console.log('{"type": "NOTIFY", "push": false, "name": "' + elementName + '", "value": "' + _countNumber + '"}' )
        createObserver(targetNode, elementName)
    }
}


function createObserver(target, targetName){
    var observer = new MutationObserver(function(mutations) {
        //~ console.log("mutation: " + mutation.type + " - " + JSON.stringify(targetName) + " - " + mutation)
        let _countNumber = target.innerText
        _countNumber = parseFloat(_countNumber) ? _countNumber : 0
        console.log('{"type": "NOTIFY", "push": true, "name": "' + targetName + '", "value": "' + _countNumber + '"}' )
    });
     
    var config = { childList: true };
     
    observer.observe(target, config);
}
