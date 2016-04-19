tests
testPoppingWhenEmptyRaisesQueueIsEmpty

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	self should: [ priorityQueue pop ] raise: QueueIsEmpty withDescription: 'Queue is empty'