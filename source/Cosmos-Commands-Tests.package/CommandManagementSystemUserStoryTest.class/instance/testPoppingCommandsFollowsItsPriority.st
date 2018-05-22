tests
testPoppingCommandsFollowsItsPriority

	self commandManagementSystem enqueue: self turnOnLedCommand with: QueuePriority medium.
	self commandManagementSystem enqueue: self turnOnLedCommand with: QueuePriority low.
	self commandManagementSystem enqueue: self turnOffLedCommand with: QueuePriority high.

	self
		assert: self commandManagementSystem pop
		equals:
			(PrioritizedCommand
				holding: self turnOffLedCommand
				with: QueuePriority high
				on: self timeSystem dateTime).
	self
		assert: self commandManagementSystem pop
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority medium
				on: self timeSystem dateTime).
	self
		assert: self commandManagementSystem pop
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority low
				on: self timeSystem dateTime)