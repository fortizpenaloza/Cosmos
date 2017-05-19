tests
testQueryingNonExistingQueue

	| interface |

	interface := CommandInterface workingWith: rootSystem.

	self
		should: [interface nextCommandFromQueueIdentifiedBy: '2' ]
		raise: ResourceNotFound.