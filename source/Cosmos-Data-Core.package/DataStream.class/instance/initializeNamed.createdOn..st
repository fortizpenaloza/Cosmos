initialize-release
initializeNamed: aName createdOn: aDateTime

	name := aName.
	creationDateTime := aDateTime.

	currentValue := Binding undefinedExplainedBy: 'Current value has not been initialized.'.
	lastUpdate := Binding
		undefinedExplainedBy: 'Last update date and time has not been initialized.'.

	dataPoints := OrderedCollection new