tests support
push: aPrioritizedCommandCollection to: aCommandPriorityQueue

	aPrioritizedCommandCollection
		do: [ :prioritizedCommand | 
			aCommandPriorityQueue
				push: prioritizedCommand command
				with: prioritizedCommand priority
				on: prioritizedCommand prioritizationDateTime ]