tests
testIsSafistied

	| condition |

	condition := IsEqualsToCondition comparingWith: 10.
	
	self
		deny: (condition isSatisfiedBy: 9.99);
		assert: (condition isSatisfiedBy: 10);
		deny: (condition isSatisfiedBy: 10.1)