tests
testCommandRegistration

	| nextCommand commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.
	
	self commandManagementSystem
		push: 'TURN_ON_LED'
		with: QueuePriority high
		toPriorityQueueIdentifiedBy: commandPriorityQueue identifier.
	self deny: commandPriorityQueue isEmpty.
	
	nextCommand := self commandManagementSystem popFromQueueIdentifiedBy: 1.
	self assert: nextCommand equals: 'TURN_ON_LED'.
	self assert: commandPriorityQueue isEmpty