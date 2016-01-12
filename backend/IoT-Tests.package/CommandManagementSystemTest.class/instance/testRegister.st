tests
testRegister

	| commandManagementSystem commandsQueue |
	
	commandManagementSystem := CommandManagementSystem using: (FixedNumberProvider providing: 1).
	
	commandManagementSystem registerCommandsQueueNamed: 'Commands queue for testing porpouses'.
	
	commandsQueue := commandManagementSystem commandsQueueIdentifiedBy: 1.
	
	self assert: commandsQueue isEmpty.
	self assert: commandsQueue name equals: 'Commands queue for testing porpouses'.
	self assert: commandsQueue identifier equals: 1