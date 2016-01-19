tests
testCommandQueueRegistration

	| commandQueue |

	self commandManagementSystem registerCommandPriorityQueue.
	commandQueue := self commandManagementSystem
		commandPriorityQueueIdentifiedBy: 1.
	self assert: commandQueue isEmpty;
		assert: commandQueue identifier equals: 1;
		assert: commandQueue timestamp equals: self timeSystem dateTime