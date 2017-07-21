tests
testTriggerOnDataPointRegistrationWhenSatisfiesDataStreamCurrentValueCondition

	| triggered dataStream conditionalTrigger |

	triggered := false.

	dataStream := self dataManagementSystem registerStreamNamed: 'Temperature'.

	conditionalTrigger := ConditionalTrigger
		firing: [ triggered := true ]
		whenMeets:
			(DataStreamCurrentValueTriggeringCondition
				of: dataStream
				isLessThan: 11)
		accordingTo: (DataPointRegistrationTriggeringPolicy on: dataStream).

	self conditionalTriggersSystem register: conditionalTrigger.
	self deny: triggered.

	self dataManagementSystem register: 12 toStreamNamed: dataStream name.
	self deny: triggered.

	self dataManagementSystem register: 10 toStreamNamed: dataStream name.
	self assert: triggered