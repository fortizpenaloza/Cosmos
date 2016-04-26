tests
testIsSafistied

	| condition |
	
	condition := IsLessThanCondition comparingWith: 10.
	
	self assert: (condition isSatisfiedBy: 9.99).
	self deny: (condition isSatisfiedBy: 10).
	self deny: (condition isSatisfiedBy: 10.1)