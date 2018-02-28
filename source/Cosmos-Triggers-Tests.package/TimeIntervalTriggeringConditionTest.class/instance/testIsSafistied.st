tests
testIsSafistied

	| condition |

	condition := TimeIntervalTriggeringCondition
		checkingCurrentTimeIsBetween: (self eightPM to: self tenPM).

	timeOfDay := self eightPM.
	self assert: (condition isSatisfiedOn: self).

	timeOfDay := self sevenPM.
	self deny: (condition isSatisfiedOn: self).

	timeOfDay := TimeOfDay hours: 20 minutes: 01.
	self assert: (condition isSatisfiedOn: self).

	timeOfDay := self tenPM.
	self assert: (condition isSatisfiedOn: self).

	timeOfDay := TimeOfDay hours: 22 minutes: 00 seconds: 01.
	self deny: (condition isSatisfiedOn: self)