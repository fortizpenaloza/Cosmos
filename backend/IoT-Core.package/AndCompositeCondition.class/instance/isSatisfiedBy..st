testing
isSatisfiedBy: aValue

	^ conditions allSatisfy: [:condition | condition isSatisfiedBy: aValue]