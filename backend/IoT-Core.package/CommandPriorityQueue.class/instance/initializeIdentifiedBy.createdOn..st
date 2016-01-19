initialize-release
initializeIdentifiedBy: anIdentifier createdOn: aDateTime 
	
	identifier := anIdentifier.
	dateTime := aDateTime.
	
	priorizedCommands := OrderedCollection new.

	lowPriority := OrderedCollection new.
	mediumPriority := OrderedCollection new.
	highPriority := OrderedCollection new
	
	