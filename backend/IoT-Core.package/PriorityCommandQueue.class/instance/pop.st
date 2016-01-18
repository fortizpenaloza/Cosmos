pushing-popping
pop

	^ highPriority
		ifEmpty:
			[ mediumPriority
				ifEmpty: [ lowPriority removeFirst ]
				ifNotEmpty: [ :collection | collection removeFirst ] ]
		ifNotEmpty: [ :collection | collection removeFirst ]