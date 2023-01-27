import QtQuick 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Lomiri.Components 1.3 as UT
import "components"
import "components/applicationheader"


Rectangle {
    id: applicationHeader
    
    readonly property real defaultHeight: 50
    readonly property real maxHeight:  appWindow.height * 0.4
    readonly property real expansionThreshold:  maxHeight * 0.50

    property list<BaseHeaderAction> leftActions
    property list<BaseHeaderAction> rightActions
    property bool expandable: true
    property Flickable flickable
    property bool floating: false
    property bool timesOut: false
    property bool alwaysHidden: false
    property int timeout: 1500
    property bool holdTimeout: false
    readonly property bool expanded: state == "Expanded"
    readonly property bool hidden: state == "Hidden"

    property alias timeOutTimer: timeOutTimer
    
    Behavior on height {
        enabled: !flickableLoader.item || (flickableLoader.item && flickableLoader.item.target.verticalOvershoot == 0) || expanded
        UT.LomiriNumberAnimation { 
            easing: UT.LomiriAnimation.StandardEasing
            duration: UT.LomiriAnimation.BriskDuration
        }
    }

    Behavior on opacity {
        UT.LomiriNumberAnimation { 
            easing: UT.LomiriAnimation.StandardEasing
            duration: UT.LomiriAnimation.SnapDuration
        }
    }

    //WORKAROUND: Label "HorizontalFit" still uses the height of the unadjusted font size.
    implicitHeight: floating ? 0 : defaultHeight
    color: "transparent"
    
    state: "Default"
    
    states: [
        State {
            name: "Default"
            PropertyChanges { target: applicationHeader; height: applicationHeader.floating ? 0 : defaultHeight; opacity: 1 }
            PropertyChanges { target: toolBar; y: 0; }
        }
        ,State {
            name: "Hidden"
            PropertyChanges { target: applicationHeader; height: 0; opacity: 0 }
            PropertyChanges { target: toolBar; y: -applicationHeader.defaultHeight; }
        }
        ,State {
            name: "Expanded"
            PropertyChanges { target: applicationHeader; height: maxHeight; opacity: 1 }
        }
    ]

    onStateChanged: {
        if (state == "Default" && timesOut) {
            timeOutTimer.restart()
        }
    }

    onExpandableChanged: {
        if (!expandable && state == "Expanded") {
            state = "Default"
        }
    }

    onHoldTimeoutChanged: {
        if (timesOut) {
            if (holdTimeout) {
                timeOutTimer.stop()
            } else {
                timeOutTimer.restart()
            }
        }
    }

    function triggerRight(fromBottom){
        if(rightActions.length > 0){
            if(rightActions.length === 1){
                rightActions[0].trigger(fromBottom)
            }else{
                rightMenu.openBottom()
            }
        }

        if (fromBottom && timesOut && !alwaysHidden) {
            state = "Default"
        }
    }

    function triggerLeft(fromBottom){
        if(leftActions.length === 1){
            leftActions[0].trigger(fromBottom)
        }

        if (fromBottom && timesOut && !alwaysHidden) {
            state = "Default"
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

    ToolBar {
        id: toolBar

        anchors {
            left: parent.left
            right: parent.right
        }
        y: 0

        height: applicationHeader.floating ? applicationHeader.state == "Expanded" ?
                                                    applicationHeader.maxHeight
                                                            : applicationHeader.defaultHeight
                        : applicationHeader.height
        
        Behavior on y {
            enabled: !flickableLoader.item || (flickableLoader.item && flickableLoader.item.target.verticalOvershoot == 0) || expanded
            UT.LomiriNumberAnimation { 
                easing: UT.LomiriAnimation.StandardEasing
                duration: UT.LomiriAnimation.BriskDuration
            }
        }

        RowLayout {
            id: rowLayout

            spacing: 10
            anchors.fill: parent

            HeaderActions {
                id: leftHeaderActions

                model: leftActions
                Layout.fillHeight: true
            }

            HeaderTitle {
                id: headerTitle

                text: stackView.currentItem ? stackView.currentItem.title : "Pesbuk"
                Layout.fillWidth: true
            }

            HeaderActions {
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

                    MenuActions {
                        id: rightMenu
                        
                        transformOrigin: Menu.TopRight
                        model: rightActions
                        onOpened: applicationHeader.holdTimeout = true
                        onClosed: applicationHeader.holdTimeout = false
                    }
                }
            }
        }

        Timer {
            id: timeOutTimer

            running: true
            interval: applicationHeader.timeout
            onTriggered: {
                if (applicationHeader.timesOut && !hoverHandler.hovered) {
                    applicationHeader.state = "Hidden"
                }
            }
        }
        
        HoverHandler {
            id: hoverHandler
            onHoveredChanged: {
                if (!hovered) {
                    timeOutTimer.restart()
                }
            }
        }
    }
}
