import Ubuntu.Components 1.3

SwipeArea{
	id: bottomSwipeArea
	
	signal triggered
	
	direction: SwipeArea.Upwards
	height: 25 //units.gu(2)
	z: 1
	anchors.bottom: parent.bottom
	
	onDraggingChanged: {
		if(dragging){
			triggered()
		}	
	}
}
