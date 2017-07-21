tests
testTriggerPeriodicallyEveryTenMinutesWhenSatisfiesDataStreamCurrentValueDuringATimeInterval

	| triggered dataStream triggerCondition trigger |

	triggered := false.

	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'.

	triggerCondition := AndCompositeTriggeringCondition
		with:
			(DataStreamCurrentValueTriggeringCondition
				of: dataStream
				isLessThan: 11)
		with:
			(TimeIntervalTriggeringCondition
				querying: self timeSystem
				toBeBetween: (self eightPM to: self ninePM)).

	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		whenMeets: triggerCondition
		accordingTo: (PeriodicalTriggeringPolicy every: self tenMinutes).

	self conditionalTriggersSystem register: trigger.
	self deny: triggered.

	self dataManagementSystem register: 10 toStreamNamed: dataStream name.
	self conditionalTriggersSystem havePassed: self tenMinutes.
	self deny: triggered.

	self dataManagementSystem register: 12 toStreamNamed: dataStream name.
	self conditionalTriggersSystem havePassed: self tenMinutes.
	self deny: triggered.

	timeSource setTimeTo: self eightPM.
	self conditionalTriggersSystem havePassed: self tenMinutes.
	self deny: triggered.

	self dataManagementSystem register: 10 toStreamNamed: dataStream name.
	self conditionalTriggersSystem havePassed: self tenMinutes.
	self assert: triggered