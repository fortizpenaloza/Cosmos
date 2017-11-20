private-querying
triggersToTriggerPeriodicallyEvery: aTimePeriod

	^ triggersToTriggerPeriodically
		at: aTimePeriod 
		ifAbsent: [ #() ]