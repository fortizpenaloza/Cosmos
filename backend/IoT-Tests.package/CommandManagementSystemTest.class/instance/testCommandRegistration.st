tests
testCommandRegistration

	| nextCommand commandQueue |

	self commandManagementSystem registerCommandPriorityQueue.
	self commandManagementSystem
		register: 'TURN_ON_LED'
		with: CommandPriority high
		toQueueIdentifiedBy: 1.
		
	commandQueue := self commandManagementSystem commandPriorityQueueIdentifiedBy: 1.
	self deny: commandQueue isEmpty.
	
	nextCommand := self commandManagementSystem nextCommandFromCommandQueueIdentifiedBy: 1.
	self assert: nextCommand equals: 'TURN_ON_LED'.
	self assert: commandQueue isEmpty