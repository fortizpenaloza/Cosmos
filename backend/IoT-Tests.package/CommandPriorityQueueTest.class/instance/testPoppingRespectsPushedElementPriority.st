tests
testPoppingRespectsPushedElementPriority

	| commandPriorityQueue |

	commandPriorityQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: (July twentyfourth , 2015) atMidnight.

	commandPriorityQueue
		push: 2
		with: QueuePriority low
		on: (July twentyfourth , 2015) atMidnight.

	commandPriorityQueue
		push: 3
		with: QueuePriority medium
		on: (July twentyfourth , 2015) atMidnight.

	commandPriorityQueue
		push: 4
		with: QueuePriority high
		on: (July twentyfourth , 2015) atMidnight.


	self assert: commandPriorityQueue pop command equals: 4.
	self assert: commandPriorityQueue pop command equals: 3.
	self assert: commandPriorityQueue pop command equals: 2