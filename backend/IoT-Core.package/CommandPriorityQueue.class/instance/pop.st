pushing-popping
pop

	| prioritizedCommand  |

	prioritizedCommand := priorityQueue pop.
	prioritizedCommands remove: prioritizedCommand.
	^ prioritizedCommand