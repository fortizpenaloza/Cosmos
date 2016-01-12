initialize-release
initializeIdentifiedBy: anIdentifier

	identifier := anIdentifier.
	currentValue := UnboundedObject failureDescription: 'Current value has not been initialized.'.
	lastUpdate := UnboundedObject failureDescription: 'Last update date and time has not been initialized.'.
	
	dataPoints := OrderedCollection new