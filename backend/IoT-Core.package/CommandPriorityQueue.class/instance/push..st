pushing-popping
push: aPrioritizedCommand

	priorityQueue
		push: (ElementWithPriority 
			holding: aPrioritizedCommand 
			with: aPrioritizedCommand priority).
	prioritizedCommands add: aPrioritizedCommand