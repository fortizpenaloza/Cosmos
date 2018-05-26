tests
testDequeuingFailsWhenQueueIsEmpty

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	self should: [ priorityQueue dequeue ] raise: QueueIsEmpty withDescription: 'Queue is empty'