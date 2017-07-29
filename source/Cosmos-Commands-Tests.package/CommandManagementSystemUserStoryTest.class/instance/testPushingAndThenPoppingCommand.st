tests
testPushingAndThenPoppingCommand

	self commandManagementSystem
		push: self turnOnLedCommand
		with: QueuePriority high.

	self
		assert: self commandManagementSystem pop
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority high
				on: self timeSystem dateTime)