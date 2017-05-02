tests
testPoppingFromQueueFailsIfEmpty

	| commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.
	self assert: commandPriorityQueue isEmpty.
	self
		should: [ self commandManagementSystem popFromQueueIdentifiedBy: commandPriorityQueue identifier ]
		raise: QueueIsEmpty
		description: 'Command queue is empty'