initialize-release
initializeIdentifiedBy: anIdentifier

	identifier := anIdentifier.
	currentValue := UnboundedObject failureDescription: 'Current value hasn''t been set.'.
	lastUpdate := UnboundedObject failureDescription: 'Last update date and time hasn''t been set.'.
	
	dataPoints := OrderedCollection new