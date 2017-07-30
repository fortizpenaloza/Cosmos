tests
testInstanceCreationAndAccessing

	| prioritizedCommand |

	prioritizedCommand := PrioritizedCommand holding: 'TURN_LED_ON' with: QueuePriority high on: self octoberFirstOf2014AtMidnight.

	self
		assert: prioritizedCommand command equals: 'TURN_LED_ON';
		assert: prioritizedCommand priority equals: QueuePriority high;
		assert: prioritizedCommand prioritizationDateTime equals: self octoberFirstOf2014AtMidnight;
		assert: prioritizedCommand hash
			equals: (prioritizedCommand command hash bitXor: (prioritizedCommand priority hash bitXor: prioritizedCommand prioritizationDateTime hash))