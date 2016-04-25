tests
testQueryingPrioritizedCommands

	| commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.

	self commandManagementSystem
		push: self turnOnLedCommand
		with: QueuePriority high
		toQueueIdentifiedBy: commandPriorityQueue identifier.
	self commandManagementSystem
		push: self turnOffLedCommand
		with: QueuePriority medium
		toQueueIdentifiedBy: commandPriorityQueue identifier.

	self
		assert: (self commandManagementSystem commandsFromQueueIdentifiedBy: commandPriorityQueue identifier)
		hasTheSameElementsInTheSameOrderThat:
			(OrderedCollection
				with:
					(PrioritizedCommand
						holding: self turnOnLedCommand
						with: QueuePriority high
						on: self timeSystem dateTime)
				with:
					(PrioritizedCommand
						holding: self turnOffLedCommand
						with: QueuePriority medium
						on: self timeSystem dateTime))