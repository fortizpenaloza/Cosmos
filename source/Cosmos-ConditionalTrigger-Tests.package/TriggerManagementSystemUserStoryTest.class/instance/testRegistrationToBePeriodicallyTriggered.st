tests
testRegistrationToBePeriodicallyTriggered

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: [ self setTriggeredToTrue ]
		periodicallyEvery: self fiveMinutes
		whenMeets: AlwaysTriggeringCondition new.

	self withTheOnlyOneIn: self triggerManagementSystem triggers do: [:trigger | 
		self assert: trigger name equals: 'Set triggered to true every 5 minutes' ]