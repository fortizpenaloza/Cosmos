initialize-release
initializeNamed: aName createdOn: aDateTime

	name := aName.
	creationDateTime := aDateTime.

	currentValue := Binding
		undefinedExplainedBy: 'Current value has not been initialized.'
		raising: BindingNotYetDefined.
	lastUpdate := Binding
		undefinedExplainedBy: 'Last update date and time has not been initialized.'
		raising: BindingNotYetDefined.

	dataPoints := OrderedCollection new