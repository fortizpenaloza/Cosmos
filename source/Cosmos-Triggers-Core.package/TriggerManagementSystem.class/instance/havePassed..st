events handling
havePassed: aTickEvent

	Transcript show: 'aca estoy'.
	
	(self triggersToTriggerPeriodicallyEvery: aTickEvent timePeriod)
		do: [ :trigger | 
			trigger
				ifSatisfiedOn: self triggeringContext
				withActionDo: [ :action | self notifyEvaluationOf: action ] ]