querying
feedIdentifiedBy: anIdentifier

	^ feeds at: anIdentifier ifAbsent: [ObjectNotFoundInSystem signal: 'Feed does not exists in system']