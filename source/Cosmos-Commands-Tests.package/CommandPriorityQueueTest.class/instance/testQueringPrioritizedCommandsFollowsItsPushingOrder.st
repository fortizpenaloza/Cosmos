tests
testQueringPrioritizedCommandsFollowsItsPushingOrder

	| commandPriorityQueue prioritizedCommands |

	commandPriorityQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: (July twentyfourth , 2015) atMidnight.

	prioritizedCommands := OrderedCollection new
		add: self turnOnLedWithLowPriority;
		add: self turnOffLedWithHighPriority;
		add: self turnOnMotorWithMediumPriority;
		yourself.

	self push: prioritizedCommands to: commandPriorityQueue.

	self
		assert: commandPriorityQueue prioritizedCommands
		hasTheSameElementsInTheSameOrderThat: prioritizedCommands