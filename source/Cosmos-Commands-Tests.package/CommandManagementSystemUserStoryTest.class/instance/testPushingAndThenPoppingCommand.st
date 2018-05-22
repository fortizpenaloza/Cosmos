tests
testPushingAndThenPoppingCommand

	self commandManagementSystem
		enqueue: self turnOnLedCommand
		with: QueuePriority high.

	self
		assert: self commandManagementSystem pop
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority high
				on: self timeSystem dateTime)