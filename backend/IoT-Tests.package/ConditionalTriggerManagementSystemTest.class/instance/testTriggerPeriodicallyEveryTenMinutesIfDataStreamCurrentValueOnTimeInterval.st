test
testTriggerPeriodicallyEveryTenMinutesIfDataStreamCurrentValueOnTimeInterval

	| triggered feed dataStream triggerCondition triggeringPolicy trigger |

	triggered := false.

	feed := self feedRegistrationSystem
		registerFeedNamed: 'Feed'
		describedAs: 'Feed for tests'.
	dataStream := self feedRegistrationSystem
		register: (DataStream identifiedBy: 'test')
		to: feed.

	triggerCondition := AndCompositeTriggerCondition
		with: (DataStreamCurrentValueTriggerCondition of: dataStream isLessThan: 11)
		with:
			(TimeIntervalTriggerCondition
				querying: self timeSystem
				toBeBetween: (self eightPM to: self ninePM)).

	triggeringPolicy := PeriodicalTriggeringPolicy every: self tenMinutes.

	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: triggerCondition
		accordingTo: triggeringPolicy.

	self triggerSystem register: trigger.
	self deny: triggered.

	self triggerSystem notifyHavePassed: self tenMinutes.
	self deny: triggered.

	timeSource setTimeTo: self eightPM.
	self triggerSystem notifyHavePassed: self tenMinutes.
	self assert: triggered