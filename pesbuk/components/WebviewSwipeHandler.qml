import QtQuick 2.4
import Lomiri.Components 1.3
import "." as Common

Common.SwipeGestureHandler {
    id: pullUpSwipeGesture

    property int triggerStage: 3
    signal trigger
    signal aboutToTrigger

    immediateRecognition: false
    grabGesture: false
    swipeHoldDuration:  700

    onStageChanged: {
        if (dragging && towardsDirection) {
            if (stage >= triggerStage) {
                aboutToTrigger()
            }
        }
    }

    onSwipeHeld: {
        if (stage >= triggerStage) {
            trigger()
        }
    }
}
