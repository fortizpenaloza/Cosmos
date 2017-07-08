tests
testIsEmptyAfterCreation

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	self assert: priorityQueue isEmpty