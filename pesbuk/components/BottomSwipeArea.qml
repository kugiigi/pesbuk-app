import Ubuntu.Components 1.3

SwipeArea{
	id: bottomSwipeArea
    
    // Enabled immediateRecognition to prevent scrolling webview when dragged, 
    // draggingCustom is used for implementing trigger delay
    property bool draggingCustom: distance >= 25 
	
	signal triggered
	
	direction: SwipeArea.Upwards
	height: 25
	z: 1
	anchors.bottom: parent.bottom
    immediateRecognition: true
	
	onDraggingCustomChanged: {
		if(dragging){
			triggered()
		}	
	}
}
