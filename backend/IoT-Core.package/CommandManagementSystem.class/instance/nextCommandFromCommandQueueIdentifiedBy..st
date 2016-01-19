querying
nextCommandFromCommandQueueIdentifiedBy: anIdentifier

	| priorityCommandQueue priorityCommand |
	
	priorityCommandQueue := self commandPriorityQueueIdentifiedBy: anIdentifier.
	priorityCommand := priorityCommandQueue pop.
	^ priorityCommand command