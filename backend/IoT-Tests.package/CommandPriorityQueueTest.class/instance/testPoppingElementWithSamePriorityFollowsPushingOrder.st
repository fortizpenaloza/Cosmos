tests
testPoppingElementWithSamePriorityFollowsPushingOrder

	| commandPriorityQueue |

	commandPriorityQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: (July twentyfourth , 2015) atMidnight.

	commandPriorityQueue
		push:
			(PrioritizedCommand
				holding: 2
				with: QueuePriority low
				on: (July twentyfourth , 2015) atMidnight).

	commandPriorityQueue
		push:
			(PrioritizedCommand
				holding: 3
				with: QueuePriority low
				on: (July twentyfourth , 2015) atMidnight).

	commandPriorityQueue
		push:
			(PrioritizedCommand
				holding: 4
				with: QueuePriority low
				on: (July twentyfourth , 2015) atMidnight).

	
	self assert: commandPriorityQueue pop command equals: 2.
	self assert: commandPriorityQueue pop command equals: 3.
	self assert: commandPriorityQueue pop command equals: 4