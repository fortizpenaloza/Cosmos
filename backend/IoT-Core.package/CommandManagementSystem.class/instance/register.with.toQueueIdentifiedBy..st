managing
register: aCommand with: aPriority toQueueIdentifiedBy: anIdentifier

	| priorizedCommand commandPriorityQueue |

	commandPriorityQueue := self commandPriorityQueueIdentifiedBy: anIdentifier.

	priorizedCommand := PriorizedCommand
		holding: aCommand
		with: aPriority
		createdOn: timeSystem dateTime.
		
	commandPriorityQueue push: priorizedCommand