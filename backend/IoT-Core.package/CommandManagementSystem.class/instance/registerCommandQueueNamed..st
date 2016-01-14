managing
registerCommandQueueNamed: aName

	| commandQueue |

	commandQueue := CommandQueue identifiedBy: identifierProvider next named: aName createdOn: timeSystem dateTime.
	self register: commandQueue.
	^ commandQueue