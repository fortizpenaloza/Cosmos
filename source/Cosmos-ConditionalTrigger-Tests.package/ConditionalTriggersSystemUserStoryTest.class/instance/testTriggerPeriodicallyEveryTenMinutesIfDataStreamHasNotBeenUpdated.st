tests
testTriggerPeriodicallyEveryTenMinutesIfDataStreamHasNotBeenUpdated

	| triggered dataStream condition conditionalTrigger |

	triggered := false.

	dataStream := self dataManagementSystem registerStreamNamed: 'Temperature'.

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		querying: timeSource
		toCheckIf: dataStream
		hasNotBeenUpdatedForMoreThan: self fiveMinutes.

	conditionalTrigger := ConditionalTrigger
		firing: [ triggered := true ]
		whenMeets: condition
		accordingTo: (PeriodicalTriggeringPolicy every: self tenMinutes).

	self conditionalTriggersSystem register: conditionalTrigger.
	self deny: triggered.

	self dataManagementSystem register: 12 toStreamNamed: dataStream name.
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self conditionalTriggersSystem havePassed: self fiveMinutes.
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self tenMinutes).
	self conditionalTriggersSystem havePassed: self tenMinutes.
	self assert: triggered