tests
testPushingAndThenPoppingCommand

	| commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.

	self commandManagementSystem
		push: self turnOnLedCommand
		with: QueuePriority high
		toQueueIdentifiedBy: commandPriorityQueue identifier.
	self deny: commandPriorityQueue isEmpty.

	self
		assert: (self commandManagementSystem popFromQueueIdentifiedBy: commandPriorityQueue identifier)
			equals: self turnOnLedCommand;
		assert: commandPriorityQueue isEmpty