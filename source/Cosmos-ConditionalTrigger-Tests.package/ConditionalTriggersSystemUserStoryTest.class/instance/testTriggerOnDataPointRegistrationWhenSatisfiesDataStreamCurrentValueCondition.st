tests
testTriggerOnDataPointRegistrationWhenSatisfiesDataStreamCurrentValueCondition

	| triggered dataChannel dataStream conditionalTrigger |

	triggered := false.

	dataChannel := self registerDataChannel.
	dataStream := self registerDataStreamTo: dataChannel.

	conditionalTrigger := ConditionalTrigger
		firing: [ triggered := true ]
		whenMeets: (DataStreamCurrentValueTriggeringCondition of: dataStream isLessThan: 11)
		accordingTo: (DataPointRegistrationTriggeringPolicy on: dataStream).

	self conditionalTriggersSystem register: conditionalTrigger.
	self deny: triggered.

	self dataManagementSystem
		register: 12
		toStreamNamed: dataStream name
		ofChannelIdentifiedBy: dataChannel identifier.
	self deny: triggered.

	self dataManagementSystem
		register: 10
		toStreamNamed: dataStream name
		ofChannelIdentifiedBy: dataChannel identifier.
	self assert: triggered