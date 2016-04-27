as yet unclassified
testIsSatisfied

	|condition|
	
	condition:= NegatedCondition with: (IsEqualsToCondition comparingWith: 10).
	
	self assert: (condition isSatisfiedBy: 8);
	     deny: (condition isSatisfiedBy: 10)
	