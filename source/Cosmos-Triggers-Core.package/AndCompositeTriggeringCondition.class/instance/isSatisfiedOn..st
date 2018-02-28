testing
isSatisfiedOn: aContext

	^ triggerConditions
		allSatisfy: [ :triggerCondition | triggerCondition isSatisfiedOn: aContext ]