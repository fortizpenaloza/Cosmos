test
testIsSafistied

	| condition |

	condition := TimeIntervalTriggerCondition
		querying: self
		toBeBetween: (self eightPM to: self tenPM).
		
	timeOfDay := self eightPM.
	self assert: condition isSatisfied.
	
	timeOfDay := self sevenPM.
	self deny: condition isSatisfied.
	
	timeOfDay := TimeOfDay hours: 20 minutes: 01.
	self assert: condition isSatisfied.
	
	timeOfDay := self tenPM.
	self assert: condition isSatisfied.
	
	timeOfDay := TimeOfDay hours: 22 minutes: 00 seconds: 01.
	self deny: condition isSatisfied