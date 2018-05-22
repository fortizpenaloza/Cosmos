tests
testQueryingPrioritizedCommands

	self commandManagementSystem
		enqueue: self turnOnLedCommand
		with: QueuePriority high.
	self commandManagementSystem
		enqueue: self turnOffLedCommand
		with: QueuePriority medium.

	self
		assert:
			(self commandManagementSystem
				prioritizedCommands)
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