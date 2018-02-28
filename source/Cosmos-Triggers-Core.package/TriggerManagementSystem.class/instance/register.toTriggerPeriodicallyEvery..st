private-managing
register: aTrigger toTriggerPeriodicallyEvery: aTimePeriod

	triggersToTriggerPeriodically
		at: aTimePeriod
		ifPresent: [ :registeredTriggers | registeredTriggers add: aTrigger ]
		ifAbsentPut: (OrderedCollection with: aTrigger)