querying
commandQueueIdentifiedBy: anIdentifier

	^ commandQueues at: anIdentifier ifAbsent: [ObjectNotFoundInSystem signal: 'Command queue does not exists in system.']