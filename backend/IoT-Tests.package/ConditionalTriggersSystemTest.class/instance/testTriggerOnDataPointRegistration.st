test
testTriggerOnDataPointRegistration

	| triggered feed dataStream condition triggeringPolicy trigger |

	triggered := false.
		
	feed := self feedsSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := self feedsSystem register: (DataStream identifiedBy: 'test') to: feed.
	
	condition := NullTriggerCondition new.
	triggeringPolicy := DataPointRegistrationTriggeringPolicy on: dataStream.

	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: condition 
		accordingTo: triggeringPolicy.		
	self triggerSystem register: trigger.

	self deny: triggered.

	self feedsSystem register: 1 to: dataStream of: feed.
	self assert: triggered