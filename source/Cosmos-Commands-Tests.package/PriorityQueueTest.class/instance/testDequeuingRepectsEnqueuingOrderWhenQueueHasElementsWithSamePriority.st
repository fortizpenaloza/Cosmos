tests
testDequeuingRepectsEnqueuingOrderWhenQueueHasElementsWithSamePriority

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	priorityQueue enqueue: 2 with: QueuePriority low.
	priorityQueue enqueue: 3 with: QueuePriority low.
	priorityQueue enqueue: 4 with: QueuePriority high.
	priorityQueue enqueue: 5 with: QueuePriority high.

	self assert: priorityQueue dequeue equals: 4.
	self assert: priorityQueue dequeue equals: 5.
	self assert: priorityQueue dequeue equals: 2.
	self assert: priorityQueue dequeue equals: 3