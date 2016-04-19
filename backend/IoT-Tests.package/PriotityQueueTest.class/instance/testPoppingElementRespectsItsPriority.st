tests
testPoppingElementRespectsItsPriority

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	priorityQueue push: (ElementWithPriority holding: 2 with: QueuePriority low).
	priorityQueue push: (ElementWithPriority holding: 3 with: QueuePriority medium).
	priorityQueue push: (ElementWithPriority holding: 4 with: QueuePriority high).

	self assert: priorityQueue pop element equals: 4.
	self assert: priorityQueue pop element equals: 3.
	self assert: priorityQueue pop element equals: 2