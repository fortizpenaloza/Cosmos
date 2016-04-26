tests
testInstanceCreationAndAccessing

	| commandPriorityQueue |

	commandPriorityQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: self julyTwentyfourth2015AtMidnight.

	self assert: commandPriorityQueue isEmpty;
		assert: commandPriorityQueue identifier equals: 1;
		assert: commandPriorityQueue creationDateTime
			equals: self julyTwentyfourth2015AtMidnight