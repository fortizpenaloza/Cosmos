querying
commandPriorityQueueIdentifiedBy: anIdentifier

	^ priorityCommandQueues
		at: anIdentifier
		ifAbsent: [ ObjectNotFoundInSystem signal: 'Command queue does not exists in system.' ]