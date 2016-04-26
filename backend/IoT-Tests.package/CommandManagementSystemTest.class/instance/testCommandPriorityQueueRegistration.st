tests
testCommandPriorityQueueRegistration

	| commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.
	self
		assert: commandPriorityQueue isEmpty;
		assert: commandPriorityQueue identifier equals: 1;
		assert: commandPriorityQueue creationDateTime equals: self timeSystem dateTime