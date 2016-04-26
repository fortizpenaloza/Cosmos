tests
testTriggerOnDataPointRegistration

	| triggered dataChannel dataStream conditionalTrigger |

	triggered := false.

	dataChannel := self registerDataChannel.
	dataStream := self registerDataStreamTo: dataChannel.

	conditionalTrigger := ConditionalTrigger
		firing: [ triggered := true ]
		whenMeets: AlwaysTriggeringCondition new
		accordingTo: (DataPointRegistrationTriggeringPolicy on: dataStream).

	self conditionalTriggersSystem register: conditionalTrigger.
	self deny: triggered.

	self dataManagementSystem
		register: 1
		toStreamNamed: dataStream name
		ofChannelIdentifiedBy: dataChannel identifier.
	self assert: triggered