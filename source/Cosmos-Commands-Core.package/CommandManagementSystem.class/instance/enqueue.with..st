managing
enqueue: aCommand with: aPriority

	| prioritizedCommand |

	prioritizedCommand := PrioritizedCommand
		holding: aCommand
		with: aPriority
		on: timeSystem dateTime.
		
	priorityQueue enqueue: prioritizedCommand with: aPriority.

	self register: prioritizedCommand.

	^ prioritizedCommand 