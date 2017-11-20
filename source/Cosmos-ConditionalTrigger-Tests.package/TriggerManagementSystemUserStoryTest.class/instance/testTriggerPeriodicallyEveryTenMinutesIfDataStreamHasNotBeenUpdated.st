tests
testTriggerPeriodicallyEveryTenMinutesIfDataStreamHasNotBeenUpdated

	| dataStream condition |

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	dataStream := self dataManagementSystem registerStreamNamed: 'Temperature'.

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		checkingIf: dataStream
		hasNotBeenUpdatedForMoreThan: self fiveMinutes.

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 10 minutes'
		triggering: [ self setTriggeredToTrue ]
		periodicallyEvery: self tenMinutes
		whenMeets: condition.

	self deny: triggered.

	self dataManagementSystem register: 12 toStreamNamed: dataStream name.
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self fiveMinutes).
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self tenMinutes).
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self tenMinutes).
	self assert: triggered