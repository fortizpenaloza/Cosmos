test
testPeriodically3

	| triggered feed dataStream condition triggeringPolicy trigger |

	feed := self feedsSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := self feedsSystem register: (DataStream identifiedBy: 'test') to: feed.
	dataStream add: (DataPoint on: self septemberTenthOf2014AtNoon holding: 10).

	triggered := false.	
	condition := AndCompositeCondition
		with: (DataStreamCurrentValueTriggerCondition of: dataStream isLessThan: 11)
		with: (TimeIntervalTriggerCondition 
					querying: self timeSystem 
					toBeBetween: (self twentyHours to: self twentyOneHours)).
	triggeringPolicy := PeriodicalTriggeringPolicy every: self tenMinutes.

	trigger := ConditionalTrigger 
		firing: [ triggered := true ] 
		when: condition 
		accordingTo: triggeringPolicy.		
	self triggerSystem register: trigger.
	
	self deny: triggered.

	self triggerSystem notifyHavePassed: self tenMinutes.
	self deny: triggered.
	
	timeSource setTimeTo: self twentyHours.	
	self triggerSystem notifyHavePassed: self tenMinutes.
	self assert: triggered.
