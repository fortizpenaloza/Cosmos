tests
testTopMustRemoveElementsAsLIFOWhenShareSamePriority

	| priorityQueue |
	
	priorityQueue := PriorityQueue empty.
	priorityQueue pushWithLowPriority: 2.
	priorityQueue pushWithLowPriority: 3.
	priorityQueue pushWithLowPriority: 4.
	
	self assert: priorityQueue top equals: 2.
	self assert: priorityQueue top equals: 3.
	self assert: priorityQueue top equals: 4.