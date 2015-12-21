testing
isSatisfiedBy: aValue 
	
	^ (IsLessThanCondition comparingWith: value) negated isSatisfiedBy: aValue