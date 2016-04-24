tests
testPushingCommand

	| commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.

	self commandManagementSystem
		push: 'TURN_ON_LED'
		with: QueuePriority high
		toQueueIdentifiedBy: commandPriorityQueue identifier.
	self deny: commandPriorityQueue isEmpty.

	self
		assert: (self commandManagementSystem popFromQueueIdentifiedBy: commandPriorityQueue identifier)
		equals: 'TURN_ON_LED'.
	self assert: commandPriorityQueue isEmpty