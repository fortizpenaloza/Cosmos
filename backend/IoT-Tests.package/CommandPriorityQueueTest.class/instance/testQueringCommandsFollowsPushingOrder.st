tests
testQueringCommandsFollowsPushingOrder

	| commandPriorityQueue firstCommand secondCommand thirdCommand |

	commandPriorityQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: (July twentyfourth , 2015) atMidnight.

	firstCommand := PriorizedCommand
		holding: 2
		with: CommandPriority low
		createdOn: (July twentyfourth , 2015) atMidnight.
	secondCommand := PriorizedCommand
		holding: 3
		with: CommandPriority high
		createdOn: (July twentyfourth , 2015) atMidnight.
	thirdCommand := PriorizedCommand
		holding: 4
		with: CommandPriority low
		createdOn: (July twentyfourth , 2015) atMidnight.

	commandPriorityQueue 
		push: firstCommand;
		push: secondCommand;
		push: thirdCommand.

	self
		assert: commandPriorityQueue commands
		hasTheSameElementsInTheSameOrderThat: (Array with: firstCommand with: secondCommand with: thirdCommand)