tests
testTriggerPeriodicallyEveryTenMinutes

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering:  self setTriggeredToTrue
		periodicallyEvery: self tenMinutes 
		ifSatisfies: AlwaysTriggeringCondition new.
	
	self deny: triggered.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self fiveMinutes).

	self deny: triggered.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
		
	self assert: triggered