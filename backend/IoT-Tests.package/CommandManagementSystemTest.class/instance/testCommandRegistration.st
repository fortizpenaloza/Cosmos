tests
testCommandRegistration

	| nextCommand commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.
	
	self commandManagementSystem
		push: 'TURN_ON_LED'
		with: CommandPriority high
		to: commandPriorityQueue.		
	self deny: commandPriorityQueue isEmpty.
	
	nextCommand := self commandManagementSystem nextCommandFromCommandQueueIdentifiedBy: 1.
	self assert: nextCommand equals: 'TURN_ON_LED'.
	self assert: commandPriorityQueue isEmpty