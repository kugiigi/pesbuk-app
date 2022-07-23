import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "components/settingspage"

BasePage {
    id: settingsPage
    
    title: i18n.tr("Settings")
    flickable: settingsFlickable
    
    
    Flickable {
        id: settingsFlickable
        
        anchors.fill: parent
        contentHeight: settingsColumn.implicitHeight + (settingsColumn.anchors.margins * 2)
        boundsBehavior: Flickable.DragOverBounds

        ScrollIndicator.vertical: ScrollIndicator { }
        
        function moveScroll(newY){
            contentY = newY
        }
    
        Column {
            id: settingsColumn
            
            spacing: 10
            
            anchors{
                fill: parent
                margins: 25
            }
    
            ComboBoxItem{       
                id: themeSettings
                        
                property int styleIndex: -1
                
                text: i18n.tr("Style")
                model: availableStyles
                currentIndex: styleIndex
                
                Component.onCompleted: {
                    styleIndex = find(appSettings.style, Qt.MatchFixedString)
                    if (styleIndex !== -1)
                        currentIndex = styleIndex
                }
                
                onCurrentIndexChanged:{
                    appSettings.style = model[currentIndex]
                }
            }

            
            Label {
                id: restartLabel
                
                text: i18n.tr("This will take effect after you restart the app")
                height: visible ? font.pixelSize : 0
                color: "#ED3146"
                visible: themeSettings.currentIndex !== themeSettings.styleIndex
                horizontalAlignment: Label.AlignRight
                verticalAlignment: Label.AlignVCenter
            }

            ComboBoxItem{       
                id: headerHideSettings
                        
                property int settingIndex: -1
                
                text: i18n.tr("Auto hide header")
                model: [
                    i18n.tr("Disabled")
                    ,i18n.tr("On scroll down")
                    ,i18n.tr("Times out")
                    ,i18n.tr("Always hide")
                ]
                currentIndex: settingIndex
                
                Component.onCompleted: {
                    currentIndex = appSettings.headerHide
                }
                
                onCurrentIndexChanged: {
                    appSettings.headerHide = currentIndex
                }
            }
            
            Label {
                id: autoHideNote
                
                text: "** " + (appSettings.headerHide == 2 ? i18n.tr("Use bottom gestures\n") : "")
                            + i18n.tr("Hover at the top to show header")
                height: visible ? font.pixelSize : 0
                visible: appSettings.headerHide >= 2
                verticalAlignment: Label.AlignVCenter
                anchors.right: parent.right
            }
            
            CheckBoxItem{
                visible: !mainView.desktopMode
                text: i18n.tr("Hide site header")

                anchors {
                    left: parent.left
                    right: parent.right
                }

                Component.onCompleted: {
                    checked = appSettings.hideHeader
                }
                onCheckedChanged: {
                    appSettings.hideHeader = checked
                }
                onClicked: refreshLabel.visible = true
            }
            
            CheckBoxItem{
                text: i18n.tr("Expand header on down swipe")

                anchors {
                    left: parent.left
                    right: parent.right
                }

                Component.onCompleted: {
                    checked = appSettings.headerExpand
                }
                onCheckedChanged: {
                    appSettings.headerExpand = checked
                }
            }

            Label {
                id: refreshLabel
                
                visible: false
                height: visible ? font.pixelSize : 0
                text: i18n.tr("Refresh the page to take effect")
                color: "#ED3146"
                verticalAlignment: Label.AlignVCenter
            }
            
            SpinRange{
                id: zoomFactor
                
                title: i18n.tr("Zoom factor") + ":"
                valueRatio: 100
                value: appSettings.zoomFactor
                onValueModified: {
                    appSettings.zoomFactor = newValue
                }
            }
            
            RadioButtonsItem{
                id: homeSiteSettings
                
                text: i18n.tr("Home Site")
                model: ["touch.facebook.com", "m.facebook.com", "Desktop", "Auto"]
                currentIndex: appSettings.baseSite
                
                onCurrentIndexChanged: {
                    appSettings.baseSite = currentIndex
                }
            }

            Label {
                id: messengerLabel
                
                text: i18n.tr("Messenger")
                verticalAlignment: Label.AlignVCenter
            }
            
            GroupBox{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                ColumnLayout{
                    Switch{
                        text: i18n.tr("Desktop version")
                        Component.onCompleted: {
                            checked = appSettings.messengerDesktop
                        }
                        onCheckedChanged: {
                            appSettings.messengerDesktop = checked
                        }
                    }
                    
                    SpinRange{
                        title: i18n.tr("Zoom factor") + ":"
                        valueRatio: 100
                        value: appSettings.messengerZoomFactor
                        onValueModified: {
                            appSettings.messengerZoomFactor = newValue
                        }
                    }
                }
            }
            
            Label {
                id: pushLabel
                
                text: i18n.tr("Push notification") + ":\n(" + i18n.tr("Prevent app suspension to enable") + ")"
                verticalAlignment: Label.AlignVCenter
            }
            
            Label {
                visible: mainView.desktopMode
                text: i18n.tr("Notifications are not working when using the desktop site")
                verticalAlignment: Label.AlignVCenter
                anchors{
                    left: parent.left
                    right: parent.right
                }
                color: "#ED3146"
                wrapMode: Text.WordWrap
            }

            GroupBox{
                visible: !mainView.desktopMode
                anchors{
                    left: parent.left
                    right: parent.right
                }
                ColumnLayout{
                
                    Switch{
                        id: notificationEnable
                        
                        text: i18n.tr("Notifications")
                        Component.onCompleted: {
                            checked = appSettings.pushNotification.enable
                        }
                        onCheckedChanged: {
                            var temp = appSettings.pushNotification
                            temp.enable = checked
                            appSettings.pushNotification = temp
                        }
                    }
                    
                    CheckBoxItem{
                        Layout.leftMargin: 20
                        visible: notificationEnable.checked
                        text: i18n.tr("Sound")
                        Component.onCompleted: {
                            checked = appSettings.pushNotification.sound
                        }
                        onCheckedChanged: {
                            var temp = appSettings.pushNotification
                            temp.sound = checked
                            appSettings.pushNotification = temp
                        }
                    }
                    
                    Switch{
                        id: messageEnable
                        
                        text: i18n.tr("Messages")
                        Component.onCompleted: {
                            checked = appSettings.pushMessage.enable
                        }
                        onCheckedChanged: {
                            var temp = appSettings.pushMessage
                            temp.enable = checked
                            appSettings.pushMessage = temp
                        }
                    }
                    
                    CheckBoxItem{
                        Layout.leftMargin: 20
                        visible: messageEnable.checked
                        text: i18n.tr("Sound")
                        Component.onCompleted: {
                            checked = appSettings.pushMessage.sound
                        }
                        onCheckedChanged: {
                            var temp = appSettings.pushMessage
                            temp.sound = checked
                            appSettings.pushMessage = temp
                        }
                    }
                    
                    Switch{
                        id: requestEnable
                        
                        text: i18n.tr("Friend requests")
                        Component.onCompleted: {
                            checked = appSettings.pushRequest.enable
                        }
                        onCheckedChanged: {
                            var temp = appSettings.pushRequest
                            temp.enable = checked
                            appSettings.pushRequest = temp
                        }
                    }
                    
                    CheckBoxItem{
                        Layout.leftMargin: 20
                        visible: requestEnable.checked
                        text: i18n.tr("Sound")
                        Component.onCompleted: {
                            checked = appSettings.pushRequest.sound
                        }
                        onCheckedChanged: {
                            var temp = appSettings.pushRequest
                            temp.sound = checked
                            appSettings.pushRequest = temp
                        }
                    }
                    
                    Switch{
                        id: feedEnable
                        
                        text: i18n.tr("Feeds")
                        Component.onCompleted: {
                            checked = appSettings.pushFeed.enable
                        }
                        onCheckedChanged: {
                            var temp = appSettings.pushFeed
                            temp.enable = checked
                            appSettings.pushFeed = temp
                        }
                    }
                    
                    CheckBoxItem{
                        Layout.leftMargin: 20
                        visible: feedEnable.checked
                        text: i18n.tr("Sound")
                        Component.onCompleted: {
                            checked = appSettings.pushFeed.sound
                        }
                        onCheckedChanged: {
                            var temp = appSettings.pushFeed
                            temp.sound = checked
                            appSettings.pushFeed = temp
                        }
                    }
                }
            }
            
        }
    }
}
