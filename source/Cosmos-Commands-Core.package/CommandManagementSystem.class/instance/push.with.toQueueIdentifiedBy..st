managing
push: aCommand with: aPriority toQueueIdentifiedBy: anIdentifier

	self
		queueIdentifiedBy: anIdentifier
		ifFound: [ :commandQueue | commandQueue push: aCommand with: aPriority on: timeSystem dateTime ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Command queue does not exists in system' ]