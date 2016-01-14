tests
testTopRemovesElementAccordingItsPriority

	| priorityQueue |
	
	priorityQueue := PriorityQueue empty.
	priorityQueue pushWithLowPriority: 2.
	priorityQueue pushWithMediumPriority: 3.
	priorityQueue pushWithHighPriority: 4.
	
	self assert: priorityQueue top equals: 4.
	self assert: priorityQueue top equals: 3.
	self assert: priorityQueue top equals: 2.