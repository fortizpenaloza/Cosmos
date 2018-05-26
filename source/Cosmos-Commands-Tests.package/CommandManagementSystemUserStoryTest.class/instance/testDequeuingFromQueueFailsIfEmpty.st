tests
testDequeuingFromQueueFailsIfEmpty

	self
		should:
			[ self commandManagementSystem dequeue ]
		raise: QueueIsEmpty
		withDescription: 'Command priority queue is empty'