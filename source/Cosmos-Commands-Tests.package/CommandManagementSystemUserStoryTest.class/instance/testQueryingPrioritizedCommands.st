tests
testQueryingPrioritizedCommands

	self commandManagementSystem
		push: self turnOnLedCommand
		with: QueuePriority high.
	self commandManagementSystem
		push: self turnOffLedCommand
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