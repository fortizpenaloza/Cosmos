installing
install

	self commandManagementSystem
		enqueue: self class turnOnLedCommand
		with: QueuePriority high