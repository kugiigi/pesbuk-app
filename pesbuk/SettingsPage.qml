import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
//~ import "components/common"
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
                color: "#ED3146"
                opacity: themeSettings.currentIndex !== themeSettings.styleIndex ? 1.0 : 0.0
                horizontalAlignment: Label.AlignRight
                verticalAlignment: Label.AlignVCenter
            }
            
            CheckBoxItem{
                text: i18n.tr("Hide header")
                Component.onCompleted: {
                    checked = appSettings.hideHeader
                }
                onCheckedChanged: {
                    appSettings.hideHeader = checked
                }
            }
            
            SpinRange{
                id: zoomFactor
            }
            
        }
    }
}
