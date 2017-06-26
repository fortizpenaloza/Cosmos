tests
testInstanceCreationAndAccessing

	| prioritizedCommand |

	prioritizedCommand := PrioritizedCommand
		holding: 'TURN_LED_ON'
		with: QueuePriority high
		on: self octoberFirstOf2015AtMidnight.

	self assert: prioritizedCommand command equals: 'TURN_LED_ON';
		assert: prioritizedCommand priority equals: QueuePriority high;
		assert: prioritizedCommand prioritizationDateTime
			equals: self octoberFirstOf2015AtMidnight