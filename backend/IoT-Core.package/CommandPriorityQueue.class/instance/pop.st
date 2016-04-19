pushing-popping
pop

	| prioritizedCommand  |

	prioritizedCommand := priorityQueue pop element.
	prioritizedCommands remove: prioritizedCommand.
	^ prioritizedCommand