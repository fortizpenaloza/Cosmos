tests
testIsSafistied

	| condition |

	condition := IsNotEqualsToCondition comparingWith: 10.
	
	self
		assert: (condition isSatisfiedBy: 9.9);
		deny: (condition isSatisfiedBy: 10);
		assert: (condition isSatisfiedBy: 10.1)