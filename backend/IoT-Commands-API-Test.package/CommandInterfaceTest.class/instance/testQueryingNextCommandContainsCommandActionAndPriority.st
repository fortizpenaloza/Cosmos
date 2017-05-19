tests
testQueryingNextCommandContainsCommandActionAndPriority

	| interface response |

	interface := CommandInterface workingWith: rootSystem.
	response := interface
		nextCommandFromQueueIdentifiedBy: self identifier asString.

	self
		assert: response
		equals: self queryingNextCommandFromPriorityQueueAnswer