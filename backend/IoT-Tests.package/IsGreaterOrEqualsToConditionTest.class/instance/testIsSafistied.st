tests
testIsSafistied

	| condition |

	condition := IsGreaterOrEqualsToCondition comparingWith: 10.
	
	self
		deny: (condition isSatisfiedBy: 9.99);
		assert: (condition isSatisfiedBy: 10);
		assert: (condition isSatisfiedBy: 10.1)