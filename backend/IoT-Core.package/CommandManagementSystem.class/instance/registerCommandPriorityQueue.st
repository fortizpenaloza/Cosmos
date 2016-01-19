managing
registerCommandPriorityQueue

	| commandQueue |

	commandQueue := CommandPriorityQueue
		identifiedBy: identifierProvider next
		createdOn: timeSystem dateTime.
		
	self register: commandQueue.
	^ commandQueue