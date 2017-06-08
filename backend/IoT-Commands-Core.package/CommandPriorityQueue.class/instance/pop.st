popping
pop

	^ [ | prioritizedCommand |

	prioritizedCommand := priorityQueue pop.
	prioritizedCommands remove: prioritizedCommand.
	prioritizedCommand ]
		on: QueueIsEmpty
		do: [ :signal | signal signal: 'Command priority queue is empty' ]