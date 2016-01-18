test
testTriggerOnDataPointRegistrationWhenSatisfiesDataStreamCurrentValueCondition

	| triggered feed dataStream condition triggeringPolicy trigger |

	triggered := false.
	
	feed := self feedManagementSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := self feedManagementSystem register: (DataStream identifiedBy: 'test') to: feed.
	
	condition := DataStreamCurrentValueTriggerCondition of: dataStream isLessThan: 11.
	triggeringPolicy := DataPointRegistrationTriggeringPolicy on: dataStream.

	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: condition 
		accordingTo: triggeringPolicy.
		
	self triggerSystem register: trigger.

	self deny: triggered.
	
	self feedManagementSystem register: 12 to: dataStream of: feed.
	self deny: triggered.
	
	self feedManagementSystem register: 10 to: dataStream of: feed.
	self assert: triggered