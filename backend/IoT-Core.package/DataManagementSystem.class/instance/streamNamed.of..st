querying
streamNamed: aName of: aDataChannel

	^ aDataChannel dataStreams
		detect: [ :dataStream | dataStream identifier = aName ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Data stream does not exists in system' ]