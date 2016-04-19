managing
push: aCommand with: aPriority to: aCommandPriorityQueue 

	| priorizedCommand |

	priorizedCommand := PrioritizedCommand
		holding: aCommand
		with: aPriority
		on: timeSystem dateTime.
		
	aCommandPriorityQueue push: priorizedCommand