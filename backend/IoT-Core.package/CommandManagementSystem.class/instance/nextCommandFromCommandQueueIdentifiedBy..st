querying
nextCommandFromCommandQueueIdentifiedBy: anIdentifier

	| commandQueue priorityCommand |
	
	commandQueue := self commandQueueIdentifiedBy: anIdentifier.
	priorityCommand := commandQueue pop.
	^ priorityCommand command