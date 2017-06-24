pushing-popping
pop

	^ highPrioritizedElements
		ifEmpty: [ mediumPrioritizedElements
				ifEmpty: [ lowPrioritizedElements
						ifEmpty: [ QueueIsEmpty signal: 'Queue is empty' ]
						ifNotEmpty: [ :collection | collection removeFirst ] ]
				ifNotEmpty: [ :collection | collection removeFirst ] ]
		ifNotEmpty: [ :collection | collection removeFirst ]