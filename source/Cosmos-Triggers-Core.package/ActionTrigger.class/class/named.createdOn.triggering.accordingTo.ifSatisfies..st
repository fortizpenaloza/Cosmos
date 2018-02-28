instance creation
named: aName createdOn: aDateTime triggering: anAction accordingTo: aTriggeringPolicy ifSatisfies: aTriggeringCondition

	^ self new
		initializeNamed: aName
		createdOn: aDateTime
		triggering: anAction
		accordingTo: aTriggeringPolicy
		ifSatisfies: aTriggeringCondition 