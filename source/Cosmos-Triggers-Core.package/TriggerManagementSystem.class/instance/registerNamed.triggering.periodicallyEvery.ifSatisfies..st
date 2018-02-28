managing
registerNamed: aName triggering: anAction periodicallyEvery: aTimePeriod ifSatisfies: aTriggeringCondition

	^ self
		registerNamed: aName
		triggering: anAction
		accordingTo: (PeriodicalTriggeringPolicy every: aTimePeriod)
		whenMeets: aTriggeringCondition