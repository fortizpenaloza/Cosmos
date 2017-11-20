instance creation
checkingIf: aDataStream hasNotBeenUpdatedForMoreThan: aTimePeriod

	^ self new
		initializeCheckingIf: aDataStream
		hasNotBeenUpdatedForMoreThan: aTimePeriod