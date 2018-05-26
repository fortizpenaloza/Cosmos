tests
testEnqueuingAndThenDequeuingCommand

	self commandManagementSystem
		enqueue: self turnOnLedCommand
		with: QueuePriority high.

	self
		assert: self commandManagementSystem dequeue
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority high
				on: self timeSystem dateTime)