managing
popFromQueueIdentifiedBy: anIdentifier

	^ self
		queueIdentifiedBy: anIdentifier
		ifFound: [ :commandQueue | commandQueue pop command ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Command queue does not exists in system' ]