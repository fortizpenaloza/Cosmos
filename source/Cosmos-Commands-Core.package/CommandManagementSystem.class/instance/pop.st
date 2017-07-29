managing
pop

	^ [ | prioritizedCommand |
			prioritizedCommand := priorityQueue pop.
			self unregister: prioritizedCommand.
			prioritizedCommand ]
		on: QueueIsEmpty
		do: [ :signal | signal signal: 'Command priority queue is empty' ]