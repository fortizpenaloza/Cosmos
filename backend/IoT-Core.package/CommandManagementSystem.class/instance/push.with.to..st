managing
push: aCommand with: aPriority to: aCommandPriorityQueue 

	| priorizedCommand |

	priorizedCommand := PriorizedCommand
		holding: aCommand
		with: aPriority
		createdOn: timeSystem dateTime.
		
	aCommandPriorityQueue push: priorizedCommand