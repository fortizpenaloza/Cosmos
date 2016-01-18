managing
register: aCommand with: aPriority to: aCommandQueueIdentifer

	| commandQueue | 
	
	commandQueue := self commandQueueIdentifiedBy: aCommandQueueIdentifer.
	
	commandQueue push: (PriorityCommand holding: aCommand with: aPriority).
	