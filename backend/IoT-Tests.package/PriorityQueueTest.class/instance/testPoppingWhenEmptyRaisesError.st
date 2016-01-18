tests
testPoppingWhenEmptyRaisesError

	| priorityQueue |
	
	priorityQueue := PriorityCommandQueue empty.
	self should: [ priorityQueue pop ] raise: CollectionIsEmpty 