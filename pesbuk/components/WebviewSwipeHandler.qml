import QtQuick 2.4
import Ubuntu.Components 1.3
import "." as Common

Common.SwipeGestureHandler {
    id: pullUpSwipeGesture

    property bool webviewPullDownState: false
    property int triggerStage: 3

    readonly property bool triggerStageReached: stage >= triggerStage

    signal trigger

    visible: enabled
    direction: webviewPullDownState ? SwipeArea.Upwards : SwipeArea.Downwards
    immediateRecognition: false
    grabGesture: true

    onTriggerStageReachedChanged: {
        if (dragging) {
            if (triggerStageReached) {
                Common.Haptics.play()
            } else {
                Common.Haptics.playSubtle()
            }
        }
    }

    onDraggingChanged: {
        if (!dragging && towardsDirection) {
            if (stage >= triggerStage) {
                trigger()
            }
        }
    }
}
