tests
testInstanceCreation

	| priorityQueue |
	
	priorityQueue := PriorityQueue empty.
	self should: [ priorityQueue top ] raise: CollectionIsEmpty 