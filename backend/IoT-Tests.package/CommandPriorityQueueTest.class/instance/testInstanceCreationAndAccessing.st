tests
testInstanceCreationAndAccessing

	| commandPriorityQueue |

	commandPriorityQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: (July twentyfourth , 2015) atMidnight.

	self assert: commandPriorityQueue isEmpty;
		assert: commandPriorityQueue identifier equals: 1;
		assert: commandPriorityQueue creationDateTime equals: (July twentyfourth , 2015) atMidnight