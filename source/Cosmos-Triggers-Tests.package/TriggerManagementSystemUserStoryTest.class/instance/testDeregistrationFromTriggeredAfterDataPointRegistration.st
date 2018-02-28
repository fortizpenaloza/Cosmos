tests
testDeregistrationFromTriggeredAfterDataPointRegistration

	| dataStream trigger |

	dataStream := self dataManagementSystem registerStreamNamed: 'Temperature'.

	trigger := self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue 
		afterDataPointWasRegisteredOn: dataStream
		ifSatisfies: AlwaysTriggeringCondition new.

	self
		assert: self triggerManagementSystem triggers
		hasTheSameElementsInTheSameOrderThat: {trigger}.
		
	self triggerManagementSystem deregisterNamed: 'Set triggered to true after data point registration'.
	
	self assert: self triggerManagementSystem triggers isEmpty 
	
