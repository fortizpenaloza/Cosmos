installing
install

	| commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.

	self commandManagementSystem push: self class turnOnLedCommand with: QueuePriority high toQueueIdentifiedBy: commandPriorityQueue identifier