tests
testIsSafistied

	| condition |

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		checkingIf: self
		hasNotBeenUpdatedForMoreThan: (TimeUnits minute with: 10).

	dateTime := September tenth , 2014 atTimeOfDay: (TimeOfDay hours: 19).
	lastUpdate := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19).
	self deny: (condition isSatisfiedOn: self).

	dateTime := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19 minutes: 20).
	lastUpdate := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19).
	self assert: (condition isSatisfiedOn: self).

	dateTime := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19 minutes: 9).
	lastUpdate := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19).
	self deny: (condition isSatisfiedOn: self)