tests
testRegistrationFailsIfTriggerWithSameNameAlreadyRegistered

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: self setTriggeredToTrue
		periodicallyEvery: self fiveMinutes
		ifSatisfies: AlwaysTriggeringCondition new.

	self
		should: [ self triggerManagementSystem
				registerNamed: 'Set triggered to true every 5 minutes'
				triggering: self setTriggeredToTrue
				periodicallyEvery: self tenMinutes
				ifSatisfies: AlwaysTriggeringCondition new ]
		raise: ObjectAlreadyInSystem
		whoseDescriptionIncludes: 'Trigger with that name already exists in system'
		description: 'Expected: Trigger with that name already exists in system'