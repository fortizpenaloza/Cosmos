tests
testPoppingElementWithSamePriorityFollowsPushingOrder

	| commandPriorityQueue |

	commandPriorityQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: (July twentyfourth , 2015) atMidnight.

	commandPriorityQueue
		push:
			(PriorizedCommand
				holding: 2
				with: CommandPriority low
				createdOn: (July twentyfourth , 2015) atMidnight).

	commandPriorityQueue
		push:
			(PriorizedCommand
				holding: 3
				with: CommandPriority low
				createdOn: (July twentyfourth , 2015) atMidnight).

	commandPriorityQueue
		push:
			(PriorizedCommand
				holding: 4
				with: CommandPriority low
				createdOn: (July twentyfourth , 2015) atMidnight).

	
	self assert: commandPriorityQueue pop command equals: 2.
	self assert: commandPriorityQueue pop command equals: 3.
	self assert: commandPriorityQueue pop command equals: 4