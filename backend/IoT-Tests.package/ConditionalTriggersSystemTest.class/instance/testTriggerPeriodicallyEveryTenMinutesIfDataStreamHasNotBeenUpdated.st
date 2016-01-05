test
testTriggerPeriodicallyEveryTenMinutesIfDataStreamHasNotBeenUpdated

	| triggered feed dataStream condition triggeringPolicy trigger |

	feed := self feedsSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := self feedsSystem register: (DataStream identifiedBy: 'test') to: feed.

	triggered := false.	
	condition := DataStreamHasNotBeenUpdatedTriggerCondition 
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

	self feedsSystem register: 1 to: dataStream of: feed.
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self tenMinutes).
	self triggerSystem notifyHavePassed: self tenMinutes.
	self assert: triggered.