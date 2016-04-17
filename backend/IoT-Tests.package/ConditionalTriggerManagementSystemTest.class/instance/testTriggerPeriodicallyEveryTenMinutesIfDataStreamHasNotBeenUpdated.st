test
testTriggerPeriodicallyEveryTenMinutesIfDataStreamHasNotBeenUpdated

	| triggered dataChannel dataStream condition triggeringPolicy trigger |

	triggered := false.
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	dataStream := self dataManagementSystem
		registerStreamNamed: 'test' toChannelIdentifiedBy: dataChannel identifier.
		
	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		querying: timeSource
		toCheckIf: dataStream
		hasNotBeenUpdatedForMoreThan: self fiveMinutes.
	triggeringPolicy := PeriodicalTriggeringPolicy every: self tenMinutes.
	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: condition
		accordingTo: triggeringPolicy.
	self triggerSystem register: trigger.

	self deny: triggered.
	
	self dataManagementSystem register: 12 toStreamNamed: dataStream name ofChannelIdentifiedBy: dataChannel identifier.
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self triggerSystem notifyHavePassed: self fiveMinutes.
	self deny: triggered.
	
	timeSource	setTimeTo: (timeSource dateTime timeOfDay next: self tenMinutes).
	self triggerSystem notifyHavePassed: self tenMinutes.
	self assert: triggered