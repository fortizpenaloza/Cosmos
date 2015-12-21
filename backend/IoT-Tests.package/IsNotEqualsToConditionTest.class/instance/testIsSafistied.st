test
testIsSafistied

	| condition |

	condition := IsNotEqualsToCondition comparingWith: 10.

	self assert: (condition isSatisfiedBy: 9.9).
	self deny: (condition isSatisfiedBy: 10).
	self assert: (condition isSatisfiedBy: 10.1).		
