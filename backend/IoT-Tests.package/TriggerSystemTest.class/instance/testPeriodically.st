test
testPeriodically

	| triggered feed dataStream condition triggeringPolicy trigger |

	triggered := false.
	
	feed := self feedSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := self feedSystem register: (DataStream identifiedBy: 'test') to: feed.
	dataStream add: (DataPoint on: self septemberTenthOf2014AtNoon holding: 10).
	
	condition := AndCompositeCondition
		with: (DataStreamCurrentValueCondition of: dataStream isLessThan: 11)
		with: (TimeIntervalCondition 
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
