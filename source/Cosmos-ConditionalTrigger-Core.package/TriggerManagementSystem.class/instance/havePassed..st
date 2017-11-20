events handling
havePassed: aTickEvent

	(self triggersToTriggerPeriodicallyEvery: aTickEvent timePeriod)
		do: [ :trigger | 
			trigger
				ifSatisfiedOn: self triggeringContext
				withActionDo: [ :action | self notifyEvaluationOf: action ] ]