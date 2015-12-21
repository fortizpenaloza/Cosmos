test
testIsSafistied

	| condition |

	condition := TimeIntervalCondition
		querying: self
		toBeBetween: ((TimeOfDay hours: 20) to: (TimeOfDay hours: 22)).
		
	timeOfDay := TimeOfDay hours: 20.
	self assert: condition isSatisfied.
	
	timeOfDay := TimeOfDay hours: 19.
	self deny: condition isSatisfied.
	
	timeOfDay := TimeOfDay hours: 20 minutes: 01.
	self assert: condition isSatisfied.
	
	timeOfDay := TimeOfDay hours: 22.
	self assert: condition isSatisfied.

	timeOfDay := TimeOfDay hours: 22 minutes: 00 seconds: 01.
	self deny: condition isSatisfied