API
streamNamed: aName

	^ self dataManagementSystem
		streamNamed: aName
		ifFound: [ :stream | dataStreamMapping value: stream ]
		ifNone: [ HTTPClientError signalNotFound ]