tests
testDeregistrationFromPeriodicallyTriggered

	| trigger |

	trigger := self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: [ self setTriggeredToTrue ]
		periodicallyEvery: self fiveMinutes
		whenMeets: AlwaysTriggeringCondition new.

	self
		assert: self triggerManagementSystem triggers
		hasTheSameElementsInTheSameOrderThat: {trigger}.
		
	self triggerManagementSystem deregisterNamed: 'Set triggered to true every 5 minutes'.
	
	self assert: self triggerManagementSystem triggers isEmpty 