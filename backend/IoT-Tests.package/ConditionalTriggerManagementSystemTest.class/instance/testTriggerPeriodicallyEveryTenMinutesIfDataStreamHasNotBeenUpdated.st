test
testTriggerPeriodicallyEveryTenMinutesIfDataStreamHasNotBeenUpdated

	| triggered feed dataStream condition triggeringPolicy trigger |

	triggered := false.

	feed := self feedRegistrationSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := self feedRegistrationSystem register: (DataStream identifiedBy: 'test') to: feed.

	condition := DataStreamHasNotBeenUpdatedTriggerCondition
		querying: timeSource
		toCheckIf: dataStream
		hasNotBeenUpdatedForMoreThan: self fiveMinutes.
	triggeringPolicy := PeriodicalTriggeringPolicy every: self tenMinutes.

	trigger := ConditionalTrigger firing: [ triggered := true ] when: condition accordingTo: triggeringPolicy.

	self triggerSystem register: trigger.
	self deny: triggered.

	self feedRegistrationSystem register: 1 to: dataStream of: feed.
	self deny: triggered.

	self triggerSystem notifyHavePassed: self fiveMinutes.
	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self tenMinutes).
	self triggerSystem notifyHavePassed: self tenMinutes.
	self assert: triggered