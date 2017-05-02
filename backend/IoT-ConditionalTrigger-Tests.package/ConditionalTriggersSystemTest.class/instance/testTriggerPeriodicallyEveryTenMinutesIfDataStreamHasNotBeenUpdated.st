tests
testTriggerPeriodicallyEveryTenMinutesIfDataStreamHasNotBeenUpdated

	| triggered dataChannel dataStream condition conditionalTrigger |

	triggered := false.

	dataChannel := self registerDataChannel.
	dataStream := self registerDataStreamTo: dataChannel.

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

	self dataManagementSystem
		register: 12
		toStreamNamed: dataStream name
		ofChannelIdentifiedBy: dataChannel identifier.
	self deny: triggered.

	timeSource
		setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self conditionalTriggersSystem notifyHavePassed: self fiveMinutes.
	self deny: triggered.

	timeSource
		setTimeTo: (timeSource dateTime timeOfDay next: self tenMinutes).
	self conditionalTriggersSystem notifyHavePassed: self tenMinutes.
	self assert: triggered