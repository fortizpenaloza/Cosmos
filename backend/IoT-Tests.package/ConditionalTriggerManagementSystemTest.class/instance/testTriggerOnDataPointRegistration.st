test
testTriggerOnDataPointRegistration
	| triggered feed dataStream condition triggeringPolicy trigger |
	triggered := false.
	feed := self feedManagementSystem registerChannelNamed: 'Feed'.
	dataStream := self feedManagementSystem
		register: (DataStream identifiedBy: 'test')
		to: feed.
	condition := AlwaysTriggeringCondition new.
	triggeringPolicy := DataPointRegistrationTriggeringPolicy
		on: dataStream.
	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: condition
		accordingTo: triggeringPolicy.
	self triggerSystem register: trigger.
	self deny: triggered.
	self feedManagementSystem register: 1 to: dataStream of: feed.
	self assert: triggered