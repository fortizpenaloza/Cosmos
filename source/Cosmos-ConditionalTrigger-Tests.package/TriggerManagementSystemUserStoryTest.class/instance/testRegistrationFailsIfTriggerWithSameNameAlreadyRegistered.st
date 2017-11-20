tests
testRegistrationFailsIfTriggerWithSameNameAlreadyRegistered

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: [ self setTriggeredToTrue ]
		periodicallyEvery: self fiveMinutes
		whenMeets: AlwaysTriggeringCondition new.

	self should: [ 	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: [ "do nothing" ]
		periodicallyEvery: self fiveMinutes
		whenMeets: AlwaysTriggeringCondition new.
 ]
			raise: ObjectAlreadyInSystem 
		whoseDescriptionIncludes: 'Trigger with that name already exists in system'
		description: 'Expected: Trigger with that name already exists in system'