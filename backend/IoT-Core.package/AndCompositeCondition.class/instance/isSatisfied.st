testing
isSatisfied

	^ conditions allSatisfy: [:condition | condition isSatisfied]