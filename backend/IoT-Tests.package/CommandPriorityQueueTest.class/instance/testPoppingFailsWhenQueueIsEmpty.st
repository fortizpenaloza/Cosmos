tests
testPoppingFailsWhenQueueIsEmpty

	| commandQueue |

	commandQueue := CommandPriorityQueue
		identifiedBy: 1
		createdOn: (July twentyfourth , 2015) atMidnight.
	self should: [ commandQueue pop ] raise: QueueIsEmpty withDescription: 'Queue is empty'