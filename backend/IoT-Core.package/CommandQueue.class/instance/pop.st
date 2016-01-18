pushing-popping
pop

	| priorityCommand |
	
	priorityCommand := priorityQueue pop.
	commands remove: priorityCommand.
	
	^ priorityCommand