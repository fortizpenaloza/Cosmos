test
testTriggerOnDataPointRegistrationWhenSatisfiesDataStreamCurrentValueCondition

	| triggered dataChannel dataStream condition triggeringPolicy trigger |

	triggered := false.
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	dataStream := self dataManagementSystem
		registerStreamNamed: 'test' toChannelIdentifiedBy: dataChannel identifier.

	condition := DataStreamCurrentValueTriggeringCondition
		of: dataStream
		isLessThan: 11.		
	triggeringPolicy := DataPointRegistrationTriggeringPolicy
		on: dataStream.
	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: condition
		accordingTo: triggeringPolicy.
	self triggerSystem register: trigger.
	self deny: triggered.
	
	self dataManagementSystem register: 12 toStreamNamed: dataStream name ofChannelIdentifiedBy: dataChannel identifier.
	self deny: triggered.
	
	self dataManagementSystem register: 10 toStreamNamed: dataStream name ofChannelIdentifiedBy: dataChannel identifier.
	self assert: triggered