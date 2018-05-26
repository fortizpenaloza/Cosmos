managing
dequeue

	^ [ | prioritizedCommand |
			prioritizedCommand := priorityQueue dequeue.
			self unregister: prioritizedCommand.
			prioritizedCommand ]
		on: QueueIsEmpty
		do: [ :signal | signal signal: 'Command priority queue is empty' ]