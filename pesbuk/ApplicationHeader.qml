import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3 as UT
import "components"
import "components/applicationheader"


ToolBar {
    id: applicationHeader
    
    readonly property real defaultHeight: 50
    readonly property real maxHeight:  mainView.height * 0.4
    readonly property real expansionThreshold:  maxHeight * 0.50
    
    property list<BaseHeaderAction> leftActions
    property list<BaseHeaderAction> rightActions
    property Flickable flickable
    property bool expanded: false
    
    //WORKAROUND: Label "HorizontalFit" still uses the height of the unadjusted font size.
    implicitHeight: defaultHeight
    
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
            expanded = false
        }
    }
    
    Loader {
        id: flickableLoader
        
        active: flickable
        asynchronous: true
        sourceComponent: Connections{
            target: flickable
            
            onVerticalOvershootChanged: {
                if(target.verticalOvershoot < 0){
                    if(applicationHeader.height < expansionThreshold){
                        applicationHeader.height = 50 - target.verticalOvershoot
                    }
                    
                    if(applicationHeader.height >= expansionThreshold){
                        expanded = true
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
    
    UT.UbuntuNumberAnimation on height{
        id: expandAnimation
        
        running: expanded
        from: height
        to: maxHeight
        easing: UT.UbuntuAnimation.StandardEasing
        duration: UT.UbuntuAnimation.BriskDuration
    }
    
    
    UT.UbuntuNumberAnimation on height{
        id: collapseAnimation
        
        running: !expanded
        from: height
        to: defaultHeight
        easing: UT.UbuntuAnimation.StandardEasing
        duration: UT.UbuntuAnimation.BriskDuration
        
        onRunningChanged: if(!running) expanded = false
    }
    
    
    RowLayout {
        id: rowLayout
        
        spacing: 10
        anchors.fill: parent
        
        HeaderActions{
            id: leftHeaderActions
            
            model: leftActions
        }
        
        HeaderTitle{
            id: headerTitle
            
            text: stackView.currentItem ? stackView.currentItem.title : "Pesbuk"
            Layout.fillWidth: true
        }
        
        HeaderActions{
            id: rightHeaderActions
            
            model: rightActions.length === 1 ? rightActions : 0
            
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

    Shortcut {
        sequence: "Menu"
        onActivated: triggerLeft(false)
    }
}
