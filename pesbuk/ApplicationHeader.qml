import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3 as UT
import "components"
import "components/applicationheader"


ToolBar {
    id: applicationHeader
    
    readonly property real defaultHeight: 50
    readonly property real maxHeight:  appWindow.height * 0.4
    readonly property real expansionThreshold:  maxHeight * 0.50
    
    property list<BaseHeaderAction> leftActions
    property list<BaseHeaderAction> rightActions
    property bool expandable: true
    property Flickable flickable
    readonly property bool expanded: state == "Expanded"
    readonly property bool hidden: state == "Hidden"
    
    Behavior on height {
        enabled: !flickableLoader.item || (flickableLoader.item && flickableLoader.item.target.verticalOvershoot == 0) || expanded
        UT.UbuntuNumberAnimation { 
            easing: UT.UbuntuAnimation.StandardEasing
            duration: UT.UbuntuAnimation.BriskDuration
        }
    }

    Behavior on opacity {
        UT.UbuntuNumberAnimation { 
            easing: UT.UbuntuAnimation.StandardEasing
            duration: UT.UbuntuAnimation.SnapDuration
        }
    }

    //WORKAROUND: Label "HorizontalFit" still uses the height of the unadjusted font size.
    implicitHeight: defaultHeight
    
    state: "Default"
    
    states: [
        State {
            name: "Default"
            PropertyChanges { target: applicationHeader; height: defaultHeight; opacity: 1 }
        }
        ,State {
            name: "Hidden"
            PropertyChanges { target: applicationHeader; height: 0; opacity: 0 }
        }
        ,State {
            name: "Expanded"
            PropertyChanges { target: applicationHeader; height: maxHeight; opacity: 1 }
        }
    ]
    
    function triggerRight(fromBottom){
        if(rightActions.length > 0){
            if(rightActions.length === 1){
                rightActions[0].trigger(fromBottom)
            }else{
                rightMenu.openBottom()
            }
        }
    }
    
    function triggerLeft(fromBottom){
        if(leftActions.length === 1){
            leftActions[0].trigger(fromBottom)
        }
    }
    
    function resetHeight(){
        if(height !== defaultHeight){
            state = "Default"
        }
    }
    
    Loader {
        id: flickableLoader
        
        active: flickable
        asynchronous: true
        sourceComponent: Connections{
            target: flickable
            
            onVerticalOvershootChanged: {
                if (applicationHeader.expandable) {
                    if(target.verticalOvershoot < 0){
                        if(applicationHeader.height < expansionThreshold){
                            applicationHeader.height = 50 - target.verticalOvershoot
                        }
                        
                        if(applicationHeader.height >= expansionThreshold){
                            applicationHeader.state = "Expanded"
                        }
                    }
                }
            }
            
            onContentYChanged:{
                if(target.contentY > 0 && expanded && !target.dragging){
                    resetHeight()
                }
            }
        }
    }
    
    RowLayout {
        id: rowLayout
        
        spacing: 10
        anchors.fill: parent
        
        HeaderActions{
            id: leftHeaderActions
            
            model: leftActions
            Layout.fillHeight: true
        }
        
        HeaderTitle{
            id: headerTitle
            
            text: stackView.currentItem ? stackView.currentItem.title : "Pesbuk"
            Layout.fillWidth: true
        }
        
        HeaderActions{
            id: rightHeaderActions
            
            model: rightActions.length === 1 ? rightActions : 0
            Layout.fillHeight: true

            HeaderToolButton {
                id: overflowRightButton
                
                visible: rightActions ? rightActions.length > 1 : false
                iconName:  "contextual-menu"
                
                onClicked: {
                    rightMenu.openTop()
                }
                
                MenuActions{
                    id: rightMenu
                    
                    transformOrigin: Menu.TopRight
                    model: rightActions
                }
            }
        }
    }
    
    ProgressBar {
        id: bar
        
        from: 0
        to: 100
        value: webview.loadProgress
        visible: opacity !== 0
        opacity: value !== to ? 1 : 0
        anchors{
            top: rowLayout.bottom
            left: parent.left
            right: parent.right
            leftMargin: -10
            rightMargin: -10
        }
        
        Behavior on opacity{ 
            UT.UbuntuNumberAnimation{
                easing: UT.UbuntuAnimation.StandardEasing
                duration: UT.UbuntuAnimation.SleepyDuration
            }
        }
    }
}
