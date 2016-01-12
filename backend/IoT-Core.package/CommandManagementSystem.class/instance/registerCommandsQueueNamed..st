managing
registerCommandsQueueNamed: aName

	| commandsQueue |

	commandsQueue := CommandsQueue identifiedBy: identifierProvider next named: aName createdOn: timeSystem dateTime.
	self register: commandsQueue.
	^ commandsQueue