removing
top

	^ [ [ highPriority removeFirst ]
		on: CollectionIsEmpty
		do: [ mediumPriority removeFirst ] ]
		on: CollectionIsEmpty
		do: [ lowPriority removeFirst ]