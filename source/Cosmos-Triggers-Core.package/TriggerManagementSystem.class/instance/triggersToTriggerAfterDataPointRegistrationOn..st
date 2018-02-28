private-querying
triggersToTriggerAfterDataPointRegistrationOn: aDataStream

	^ triggersToTriggerAfterDataPointRegistration
		at: aDataStream
		ifAbsent: [ #() ]