testing
isSatisfied
	
	^ triggerConditions allSatisfy: [ :triggerCondition | triggerCondition isSatisfied ]