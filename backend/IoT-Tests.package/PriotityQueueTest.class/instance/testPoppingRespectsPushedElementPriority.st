tests
testPoppingRespectsPushedElementPriority

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	priorityQueue push: 2 with: QueuePriority low.
	priorityQueue push: 3 with: QueuePriority medium.
	priorityQueue push: 4 with: QueuePriority high.

	self assert: priorityQueue pop equals: 4.
	self assert: priorityQueue pop equals: 3.
	self assert: priorityQueue pop equals: 2