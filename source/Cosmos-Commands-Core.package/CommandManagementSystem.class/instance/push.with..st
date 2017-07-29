managing
push: aCommand with: aPriority

	| prioritizedCommand |

	prioritizedCommand := PrioritizedCommand
		holding: aCommand
		with: aPriority
		on: timeSystem dateTime.
		
	priorityQueue push: prioritizedCommand with: aPriority.

	self register: prioritizedCommand 
