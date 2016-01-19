tests
testIsSatisfied

	| condition |

	condition := AndCompositeTriggeringCondition
		withAll:
			(OrderedCollection
				with: (TimeIntervalTriggeringCondition querying: self toBeBetween: (self eightPM to: self tenPM))
				with: (DataStreamCurrentValueTriggeringCondition of: self isLessThan: 10)).

	currentValue := 9.
	timeOfDay := self eightPM.
	self assert: condition isSatisfied.

	currentValue := 10.
	timeOfDay := self eightPM.
	self deny: condition isSatisfied.

	currentValue := 9.
	timeOfDay := self elevenPM.
	self deny: condition isSatisfied