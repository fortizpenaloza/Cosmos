test
testTriggerOnDataPointRegistration

	| triggered feed dataStream condition triggeringPolicy trigger |

	triggered := false.
		
	feed := self feedRegistrationSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := self feedRegistrationSystem register: (DataStream identifiedBy: 'test') to: feed.
	
	condition := AlwaysTriggerCondition new.
	triggeringPolicy := DataPointRegistrationTriggeringPolicy on: dataStream.

	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: condition 
		accordingTo: triggeringPolicy.		
	self triggerSystem register: trigger.

	self deny: triggered.

	self feedRegistrationSystem register: 1 to: dataStream of: feed.
	self assert: triggered