test
testIsSafistied

	| condition |

	condition := AndCompositeCondition
		with: (IsGreaterThanCondition comparingWith: 10)
		with: (IsLessThanCondition comparingWith: 11).
		
	self assert: (condition isSatisfiedBy: 10.5).
	self deny: (condition isSatisfiedBy: 10).
	self deny: (condition isSatisfiedBy: 11)