import QtQuick 2.9
import Lomiri.Components 1.3
import "." as Local

Local.SwipeGestureHandler {
    id: horizontalSwipeHandle

    property bool leftSwipeHoldEnabled: true
    property bool rightSwipeHoldEnabled: true
    property bool leftSwipeEnabled: true
    property bool rightSwipeEnabled: true

    property var leftAction
    property var rightAction

    signal leftSwipe
    signal rightSwipe
    signal leftSwipeHeld
    signal rightSwipeHeld

    direction: SwipeArea.Horizontal

    function assessAction(swipeHold) {
        if ( (usePhysicalUnit && stage >= 2)
             || (!usePhysicalUnit && stage >= 4)
           ) {
            if (distance > 0 && rightSwipeEnabled) {
                if (swipeHold) {
                    if (rightSwipeHoldEnabled) {
                        leftAction.heldState = true
                        Local.Haptics.play()
                        rightSwipeHeld()
                        internal.delayedHideActions()
                    }
                } else {
                    rightSwipe()
                    internal.hideActions()
                }
            }
            if (distance < 0 && leftSwipeEnabled) {
                if (swipeHold) {
                    if (leftSwipeHoldEnabled) {
                        rightAction.heldState = true
                        Local.Haptics.play()
                        leftSwipeHeld()
                        internal.delayedHideActions()
                    }
                } else {
                    leftSwipe()
                    internal.hideActions()
                }
            }
        }
    }

    onSwipeHeld: {
        internal.swipeHeld = true
        assessAction(true)
    }

    onStageChanged: {
        if (dragging) {
            if ( (usePhysicalUnit && stage >= 2)
                 || (!usePhysicalUnit && stage >= 4)
               ) {
                if (distance > 0 && rightSwipeEnabled) {
                    leftAction.show()
                    if (!leftAction.visible) {
                        Local.Haptics.play()
                    }
                } else if (distance < 0 && leftSwipeEnabled) {
                    rightAction.show()
                    if (!rightAction.visible) {
                        Local.Haptics.play()
                    }
                }
            } else {
                internal.hideActions()
                if (leftAction.opacity > 0 || rightAction.opacity > 0) {
                    Local.Haptics.playSubtle()
                }
            }
        }
    }

    onDraggingChanged: {
        if (!dragging) {
            if (!internal.swipeHeld) {
                assessAction(false)
            } else {
                internal.hideActions()
            }

            // Reset the flag
            internal.swipeHeld = false
        }
    }

    Timer {
        id: delayTimer
        interval: 400
        running: false
        onTriggered: {
            internal.hideActions()
        }
    }

    QtObject {
        id: internal
        property bool swipeHeld: false // Use to cancel normal left and right swipe

        function hideActions() {
            horizontalSwipeHandle.leftAction.hide()
            horizontalSwipeHandle.rightAction.hide()
        }

        function delayedHideActions() {
            delayTimer.restart()
        }
    }
}
