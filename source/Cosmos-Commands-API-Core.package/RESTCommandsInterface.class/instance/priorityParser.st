parsers
priorityParser

	^ CaseBasedParser new
		parsing: 'high' to: QueuePriority high;
		parsing: 'medium' to: QueuePriority medium;
		parsing: 'low' to: QueuePriority low;
		yourself.
