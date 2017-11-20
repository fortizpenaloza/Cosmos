managing
registerNamed: aName triggering: anAction afterDataPointWasRegisteredOn: aDataStream whenMeets: aTriggeringCondition

	^ self
		registerNamed: aName
		triggering: anAction
		accordingTo: (DataPointRegistrationTriggeringPolicy on: aDataStream)
		whenMeets: aTriggeringCondition