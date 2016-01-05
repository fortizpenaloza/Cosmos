querying
dataStreamIdentifiedBy: anIdentifier of: aFeed

	^ aFeed dataStreams
		detect: [ :dataStream | dataStream identifier = anIdentifier ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Data stream does not exists in system' ]