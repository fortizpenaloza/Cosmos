tests
testQueryingNextCommandContainsCommandActionAndPriority

	| interface response |

	interface := CommandsInterface workingWith: rootSystem.
	response := interface
		nextCommandFromQueueIdentifiedBy: self identifier.

	self
		assert: response
		equals: '"TURN_ON_LED"'