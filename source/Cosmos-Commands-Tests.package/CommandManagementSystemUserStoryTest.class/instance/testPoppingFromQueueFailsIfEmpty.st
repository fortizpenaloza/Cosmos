tests
testPoppingFromQueueFailsIfEmpty

	self
		should:
			[ self commandManagementSystem pop ]
		raise: QueueIsEmpty
		withDescription: 'Command priority queue is empty'