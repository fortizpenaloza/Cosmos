test
testIsSafistied

	| condition |

	condition := IsGreaterOrEqualsToCondition comparingWith: 10.
	
	self deny: (condition isSatisfiedBy: 9.99).
	self assert: (condition isSatisfiedBy: 10).
	self assert: (condition isSatisfiedBy: 10.1)