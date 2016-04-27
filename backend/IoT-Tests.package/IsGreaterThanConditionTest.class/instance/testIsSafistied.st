tests
testIsSafistied

	| condition |

	condition := IsGreaterThanCondition comparingWith: 10.
	
	self
		deny: (condition isSatisfiedBy: 9.99);
		deny: (condition isSatisfiedBy: 10);
		assert: (condition isSatisfiedBy: 10.1)