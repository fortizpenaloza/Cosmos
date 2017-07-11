querying
commandsFromQueueIdentifiedBy: anIdentifier

	^ self
		queueIdentifiedBy: anIdentifier
		ifFound: [ :commandQueue | commandQueue prioritizedCommands ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Command queue does not exists in system' ]