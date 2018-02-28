tests
testIsSatisfied

	| condition |

	condition := AndCompositeTriggeringCondition
		withAll:
			(OrderedCollection
				with:
					(TimeIntervalTriggeringCondition
						checkingCurrentTimeIsBetween: (self eightPM to: self tenPM))
				with: (DataStreamCurrentValueTriggeringCondition of: self isLessThan: 10)).

	currentValue := 9.
	timeOfDay := self eightPM.
	self assert: (condition isSatisfiedOn: self).

	currentValue := 10.
	timeOfDay := self eightPM.
	self deny: (condition isSatisfiedOn: self).

	currentValue := 9.
	timeOfDay := self elevenPM.
	self deny: (condition isSatisfiedOn: self)