events handling
dataPointRegisteredOn: anEvent

	(self triggersToTriggerAfterDataPointRegistrationOn: anEvent dataStream)
		do: [ :trigger | 
			trigger
				ifSatisfiedOn: self triggeringContext
				withActionDo: [ :action | self notifyEvaluationOf: action ] ]