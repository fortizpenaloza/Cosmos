pushing-popping private
popIfEmptyDo: aBlock

	^ highPriority
		ifEmpty:
			[ mediumPriority
				ifEmpty:
					[ lowPriority ifEmpty: aBlock ifNotEmpty: [ :collection | collection removeFirst ] ]
				ifNotEmpty: [ :collection | collection removeFirst ] ]
		ifNotEmpty: [ :collection | collection removeFirst ]