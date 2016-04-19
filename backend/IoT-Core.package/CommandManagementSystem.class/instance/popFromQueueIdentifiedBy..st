pushing-popping
popFromQueueIdentifiedBy: anIdentifier

	| priorityCommandQueue prioritizedCommand |
	
	priorityCommandQueue := self commandPriorityQueueIdentifiedBy: anIdentifier.
	prioritizedCommand := priorityCommandQueue pop.
	^ prioritizedCommand command