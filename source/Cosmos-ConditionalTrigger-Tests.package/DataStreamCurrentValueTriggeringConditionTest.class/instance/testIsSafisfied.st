tests
testIsSafisfied

	| condition |

	condition := DataStreamCurrentValueTriggeringCondition of: self isLessThan: 10.
	
	currentValue := 9.99.
	self assert: (condition isSatisfiedOn: self).
	
	currentValue := 10.
	self deny: (condition isSatisfiedOn: self).
	
	currentValue := 10.1.
	self deny: (condition isSatisfiedOn: self)