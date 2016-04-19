tests
testQueringCommandsFollowsPushingOrder

	| commandPriorityQueue firstCommand secondCommand thirdCommand |

	commandPriorityQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: (July twentyfourth , 2015) atMidnight.

	firstCommand := PrioritizedCommand
		holding: 2
		with: QueuePriority low
		on: (July twentyfourth , 2015) atMidnight.
	secondCommand := PrioritizedCommand
		holding: 3
		with: QueuePriority high
		on: (July twentyfourth , 2015) atMidnight.
	thirdCommand := PrioritizedCommand
		holding: 4
		with: QueuePriority low
		on: (July twentyfourth , 2015) atMidnight.

	commandPriorityQueue 
		push: firstCommand;
		push: secondCommand;
		push: thirdCommand.

	self
		assert: commandPriorityQueue prioritizedCommands
		hasTheSameElementsInTheSameOrderThat: (Array with: firstCommand with: secondCommand with: thirdCommand)