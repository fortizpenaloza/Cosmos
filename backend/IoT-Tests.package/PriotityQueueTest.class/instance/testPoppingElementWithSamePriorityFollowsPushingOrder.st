tests
testPoppingElementWithSamePriorityFollowsPushingOrder

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	priorityQueue push: 2 with: QueuePriority low.
	priorityQueue push: 3 with: QueuePriority low.
	priorityQueue push: 4 with: QueuePriority low.

	self assert: priorityQueue pop equals: 2.
	self assert: priorityQueue pop equals: 3.
	self assert: priorityQueue pop equals: 4