testing
isSatisfiedBy: aValue
	
	^ (IsGreaterThanCondition comparingWith: value) negated isSatisfiedBy: aValue