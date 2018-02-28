private-managing
register: aTrigger toTriggerAfterDataPointRegistrationOn: aDataStream

	triggersToTriggerAfterDataPointRegistration 
		at: aDataStream 
		ifPresent: [ :registeredTriggers | registeredTriggers add: aTrigger ] 
		ifAbsentPut: (OrderedCollection with: aTrigger)