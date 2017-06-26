tests
testPoppingCommandsFollowsItsPriority

	| commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.

	self commandManagementSystem
		push: self turnOnLedCommand
		with: QueuePriority low
		toQueueIdentifiedBy: commandPriorityQueue identifier.
	self commandManagementSystem
		push: self turnOffLedCommand
		with: QueuePriority high
		toQueueIdentifiedBy: commandPriorityQueue identifier.

	self
		assert: (self commandManagementSystem popFromQueueIdentifiedBy: commandPriorityQueue identifier)
		equals: self turnOffLedCommand.
	self
		assert: (self commandManagementSystem popFromQueueIdentifiedBy: commandPriorityQueue identifier)
		equals: self turnOnLedCommand