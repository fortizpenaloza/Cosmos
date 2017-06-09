installing
install

	| commandPriorityQueue |

	commandPriorityQueue := self commandManagementSystem registerCommandPriorityQueue.

	self commandManagementSystem
		push: self turnOnLedCommand
		with: QueuePriority high
		toQueueIdentifiedBy: commandPriorityQueue identifier