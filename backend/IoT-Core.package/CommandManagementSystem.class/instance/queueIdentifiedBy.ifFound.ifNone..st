querying
queueIdentifiedBy: anIdentifier ifFound: aFoundBlock ifNone: aNoneBlock

	^ commandPriorityQueues
		at: anIdentifier
		ifPresent: [ :commandQueue | aFoundBlock value: commandQueue ]
		ifAbsent: aNoneBlock