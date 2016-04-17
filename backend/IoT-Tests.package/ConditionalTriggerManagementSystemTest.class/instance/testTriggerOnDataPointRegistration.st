test
testTriggerOnDataPointRegistration

	| triggered dataChannel dataStream condition triggeringPolicy trigger |

	triggered := false.
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	dataStream := self dataManagementSystem
		registerStreamNamed: 'test' toChannelIdentifiedBy: dataChannel identifier.

	condition := AlwaysTriggeringCondition new.
	triggeringPolicy := DataPointRegistrationTriggeringPolicy
		on: dataStream.
	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: condition
		accordingTo: triggeringPolicy.

	self triggerSystem register: trigger.
	self deny: triggered.
	
	self dataManagementSystem register: 1 toStreamNamed: dataStream name ofChannelIdentifiedBy: dataChannel identifier.
	self assert: triggered