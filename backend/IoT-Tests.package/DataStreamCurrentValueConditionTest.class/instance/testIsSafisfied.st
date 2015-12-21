test
testIsSafisfied

	| condition |

	condition := DataStreamCurrentValueCondition of: self isLessThan: 10.
	
	currentValue := 9.99.
	self assert: condition isSatisfied.
	
	currentValue := 10.
	self deny: condition isSatisfied.
	
	currentValue := 10.1.
	self deny: condition isSatisfied