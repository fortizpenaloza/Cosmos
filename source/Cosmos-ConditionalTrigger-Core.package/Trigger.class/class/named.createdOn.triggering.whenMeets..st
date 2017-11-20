instance creation
named: aName createdOn: aDateTime triggering: anAction whenMeets: aTriggeringCondition

	^ self new
		initializeNamed: aName
		createdOn: aDateTime
		triggering: anAction
		whenMeets: aTriggeringCondition