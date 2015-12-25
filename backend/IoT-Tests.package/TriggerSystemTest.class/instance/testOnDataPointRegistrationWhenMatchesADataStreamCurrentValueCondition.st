test
testOnDataPointRegistrationWhenMatchesADataStreamCurrentValueCondition

	| triggered feed dataStream condition triggeringPolicy trigger |

	triggered := false.
	
	feed := self feedSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := self feedSystem register: (DataStream identifiedBy: 'test') to: feed.
	dataStream add: (DataPoint on: self septemberTenthOf2014AtNoon holding: 10).
	
	condition := DataStreamCurrentValueCondition of: dataStream isLessThan: 11.
	triggeringPolicy := DataPointRegistrationTriggeringPolicy on: dataStream.

	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: condition 
		accordingTo: triggeringPolicy.
		
	self triggerSystem register: trigger.

	self deny: triggered.
	self triggerSystem notifyDataPointRegistrationOn: dataStream of: feed.
	self assert: triggered