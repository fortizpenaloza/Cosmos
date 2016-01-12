tests
testIsSatisfied

	| condition |

	condition := AndCompositeTriggerCondition
		withAll:
			(OrderedCollection
				with:
					(TimeIntervalTriggerCondition
						querying: self
						toBeBetween: ((self eightPM) to: (self tenPM)))
				with: (DataStreamCurrentValueTriggerCondition of: self isLessThan: 10)).
				
	currentValue := 9.
	timeOfDay := self eightPM.
	self assert: (condition isSatisfied).
	
	currentValue := 10.
	timeOfDay := self eightPM.
	self deny: (condition isSatisfied).
	
	currentValue := 9.
	timeOfDay := self elevenPM.
	self deny: (condition isSatisfied)