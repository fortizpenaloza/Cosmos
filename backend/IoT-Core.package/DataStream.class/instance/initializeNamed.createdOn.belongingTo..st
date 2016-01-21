initialize-release
initializeNamed: aName createdOn: aDateTime belongingTo: aDataChannel

	name := aName.
	creationDateTime := aDateTime.
	dataChannel := aDataChannel.
	
	currentValue := UnboundedObject failureDescription: 'Current value has not been initialized.'.
	lastUpdate := UnboundedObject failureDescription: 'Last update date and time has not been initialized.'.
	
	dataPoints := OrderedCollection new