import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ColumnLayout{
    id: spinRange
    
    property alias title: title.text
    property real value: 1
    property alias validator: spinBox.validator
    property alias from: spinBox.from
    property alias to: spinBox.to
    property alias stepSize: spinBox.stepSize
    property real valueRatio: 1
    
    signal valueModified (real newValue)
    
    Label{
        id: title

        Layout.fillWidth: true
    }
    
    SpinBox {
        id: spinBox
        
        property int decimals: 2
        property real realValue: value / spinRange.valueRatio
        
        from: 25
        to: 500
        stepSize: 25

        Component.onCompleted: {
            value = spinRange.value * spinRange.valueRatio
        }
        
        validator: DoubleValidator {
            bottom: Math.min(spinBox.from, spinBox.to)
            top:  Math.max(spinBox.from, spinBox.to)
        }
        
        textFromValue: function(value, locale) {
            return Number(value / spinRange.valueRatio).toLocaleString(locale, 'f', spinBox.decimals)
        }
        
        valueFromText: function(text, locale) {
            return Number.fromLocaleString(locale, text) * spinRange.valueRatio
        }
        
        onValueModified: {
            spinRange.valueModified(realValue)
        }
    }
}
