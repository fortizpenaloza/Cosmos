managing
push: aCommand with: aPriority toPriorityQueueIdentifiedBy: anIdentifier

	| commandPriorityQueue |

	commandPriorityQueue := self commandPriorityQueueIdentifiedBy: anIdentifier.
	self push: aCommand with: aPriority to: commandPriorityQueue