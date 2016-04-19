testing
isEmpty

	^ (Array
		with: lowPrioritizedElements
		with: mediumPrioritizedElements
		with: highPrioritizedElements) allSatisfy: [ :collection | collection isEmpty ]