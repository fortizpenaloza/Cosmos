tests
testTriggerOnDataPointRegistrationWhenSatisfiesDataStreamCurrentValueCondition

	| dataStream conditionalTrigger |

	dataStream := self dataManagementSystem registerStreamNamed: 'Temperature'.

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #setTriggeredToTrue.

	conditionalTrigger := ConditionalTrigger
		firing: 'Set triggered to true'
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