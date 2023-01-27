import QtQuick 2.9
import QtQuick.Controls 2.5 as QQC2

QQC2.Action {
    property bool closeMenuOnTrigger: false
    property bool displayWhenDisabled: false

    property string type
    property string url
    property string notifyText
    
    onTriggered: {
        switch(type){
            case "PAGE":
                stackView.push(url)
                break
            case "URL":
                webview.url = url
                break
            case "JS":
                webview.runJavaScript(url)
                break
        }
    }
}
