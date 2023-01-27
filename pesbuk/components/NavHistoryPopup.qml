import QtQuick 2.9
import Lomiri.Components 1.3
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Controls.Suru 2.2

QQC2.Popup {
    id: navHistoryPopup

    property alias model: historyListView.model

    property bool incognito: false
    property bool shownAtBottom: false
    property real availHeight
    property real availWidth
    property real maximumWidth: units.gu(70)
    property real preferredWidth: availWidth - units.gu(4)

    readonly property real marginAtBottom: units.gu(1)

    signal navigate(int offset)

    width: Math.min(preferredWidth, maximumWidth)
    height: scrollView.height
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    modal: shownAtBottom
    dim: false

    function show(fromBottom, caller){
        shownAtBottom = fromBottom
        var mapped = caller.mapToItem(parent, 0, 0)
        x = Qt.binding(function(){
                if (width == maximumWidth) {
                    return mapped.x
                } else {
                    return (availWidth - width) / 2
                }
            })
        if (fromBottom) {
            y = Qt.binding(function() { return mapped.y - navHistoryPopup.height - marginAtBottom} )
        } else {
            y = mapped.y + caller.height
        }
        open()
    }

    onVisibleChanged: {
        if (visible) {
            historyListView.forceActiveFocus()
            historyListView.currentIndex = -1
        }
    }

    ScrollView {
        id: scrollView

        property real maximumHeight: navHistoryPopup.availHeight - units.gu(2)
        property real preferredHeight:  historyListView.contentItem.height

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        height: Math.min(preferredHeight, maximumHeight)

        LomiriListView {
            id: historyListView

            anchors.fill: parent
            verticalLayoutDirection: navHistoryPopup.shownAtBottom ? ListView.BottomToTop : ListView.TopToBottom

            delegate: ListItem {
                id: listItem

                height: layout.height + (divider.visible ? divider.height : 0)
                divider.visible: false

                onClicked: {
                    close()
                    navigate(model.offset)
                }

                MouseArea {
                    id: hover
                    
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                    anchors.fill: parent
                }

                Rectangle {
                    id: hoverBg

                    anchors.fill: parent
                    opacity: 0.2
                    visible: hover.containsMouse && !listItem.ListView.isCurrentItem
                    color: Suru.highlightColor
                }

                ListItemLayout {
                    id: layout

                    title.text: model.title
                    title.color: Suru.foregroundColor
                    
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading;
                        name: model.offset < 0 ? "go-previous" : "go-next"
                        height: units.gu(2)
                        width: height
                        visible: model.index == 0 && historyListView.count > 1
                        color: Suru.foregroundColor
                    }
                }
            }
        }
    }
}
