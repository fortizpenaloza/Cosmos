tests
testIsSafistied

	| condition |

	condition := AndCompositeCondition
		with: (IsGreaterThanCondition comparingWith: 10)
		with: (IsLessThanCondition comparingWith: 11).
		
	self
		assert: (condition isSatisfiedBy: 10.5);
		deny: (condition isSatisfiedBy: 10);
		deny: (condition isSatisfiedBy: 11)