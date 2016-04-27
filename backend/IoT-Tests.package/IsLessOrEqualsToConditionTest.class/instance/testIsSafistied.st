tests
testIsSafistied

	| condition |

	condition := IsLessOrEqualsToCondition comparingWith: 10.
	
	self
		assert: (condition isSatisfiedBy: 9.99);
		assert: (condition isSatisfiedBy: 10);
		deny: (condition isSatisfiedBy: 10.1)