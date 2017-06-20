initialize-release
initializeNamed: aName createdOn: aDateTime belongingTo: aDataChannel

	name := aName.
	creationDateTime := aDateTime.
	dataChannel := aDataChannel.

	currentValue := Binding undefinedExplainedBy: 'Current value has not been initialized.'.
	lastUpdate := Binding
		undefinedExplainedBy: 'Last update date and time has not been initialized.'.

	dataPoints := OrderedCollection new