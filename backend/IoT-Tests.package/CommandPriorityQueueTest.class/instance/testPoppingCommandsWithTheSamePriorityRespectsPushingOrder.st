tests
testPoppingCommandsWithTheSamePriorityRespectsPushingOrder

	| commandPriorityQueue prioritizedCommands |

	commandPriorityQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: (July twentyfourth , 2015) atMidnight.

	prioritizedCommands := OrderedCollection new
		add: self turnOnLedWithLowPriority;
		add: self turnOffLedWithHighPriority;
		add: self turnOnLedWithMediumPriority;
		add: self turnOnMotorWithMediumPriority;
		yourself.

	self push: prioritizedCommands to: commandPriorityQueue.

	self
		assert: commandPriorityQueue pop equals: self turnOffLedWithHighPriority;
		assert: commandPriorityQueue pop equals: self turnOnLedWithMediumPriority;
		assert: commandPriorityQueue pop equals: self turnOnMotorWithMediumPriority;
		assert: commandPriorityQueue pop equals: self turnOnLedWithLowPriority;
		assert: commandPriorityQueue isEmpty