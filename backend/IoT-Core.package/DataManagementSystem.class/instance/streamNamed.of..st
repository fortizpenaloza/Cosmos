querying
streamNamed: aName of: aChannel

	^ aChannel dataStreams
		detect: [ :dataStream | dataStream identifier = aName ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Data stream does not exists in system' ]