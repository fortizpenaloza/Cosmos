tests
testTriggerPeriodicallyEveryTenMinutesWhenSatisfiesDataStreamCurrentValueDuringATimeInterval

	| dataStream condition |

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'.

	condition := AndCompositeTriggeringCondition
		with:
			(DataStreamCurrentValueTriggeringCondition
				of: dataStream
				isLessThan: 11)
		with:
			(TimeIntervalTriggeringCondition
				checkingCurrentTimeIsBetween: (self eightPM to: self ninePM)).

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: [ self setTriggeredToTrue ]
		periodicallyEvery: self tenMinutes
		whenMeets: condition .

	self deny: triggered.

	self dataManagementSystem register: 10 toStreamNamed: dataStream name.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.

	self dataManagementSystem register: 12 toStreamNamed: dataStream name.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.

	timeSource setTimeTo: self eightPM.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.

	self dataManagementSystem register: 10 toStreamNamed: dataStream name.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
	self assert: triggered