testing
ifSatisfiedOn: aContext withActionDo: aBlock

	(condition isSatisfiedOn: aContext)
		ifTrue: [ aBlock value: action ]