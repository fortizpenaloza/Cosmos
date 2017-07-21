tests
testTriggerOnDataPointRegistration

	| triggered dataStream conditionalTrigger |

	triggered := false.

	dataStream := self dataManagementSystem registerStreamNamed: 'Temperature'.

	conditionalTrigger := ConditionalTrigger
		firing: [ triggered := true ]
		whenMeets: AlwaysTriggeringCondition new
		accordingTo: (DataPointRegistrationTriggeringPolicy on: dataStream).

	self conditionalTriggersSystem register: conditionalTrigger.
	self deny: triggered.

	self dataManagementSystem register: 12 toStreamNamed: dataStream name.
	self assert: triggered