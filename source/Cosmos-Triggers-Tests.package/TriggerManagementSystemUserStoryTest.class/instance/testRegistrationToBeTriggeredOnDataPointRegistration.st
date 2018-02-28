tests
testRegistrationToBeTriggeredOnDataPointRegistration

	| dataStream |

	dataStream := self dataManagementSystem registerStreamNamed: 'Temperature'.

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		afterDataPointWasRegisteredOn: dataStream
		ifSatisfies: AlwaysTriggeringCondition new.

	self withTheOnlyOneIn: self triggerManagementSystem triggers do: [:trigger | 
		self assert: trigger name equals: 'Set triggered to true after data point registration' ]