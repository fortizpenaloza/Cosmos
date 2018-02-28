tests
testTriggeringOnDataPointRegistration

	|  dataStream |

	dataStream := self dataManagementSystem registerStreamNamed: 'Temperature'.

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		afterDataPointWasRegisteredOn: dataStream
		ifSatisfies: AlwaysTriggeringCondition new.

	self deny: triggered.
	self dataManagementSystem register: 12 toStreamNamed: dataStream name.
	self assert: triggered