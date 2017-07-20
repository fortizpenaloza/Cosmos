API
streamNamed: aName ofChannelIdentifiedBy: anIdentifier

	^ self dataManagementSystem
		streamNamed: aName
		ofChannelIdentifiedBy: anIdentifier asNumber
		ifFound: [ :stream | dataStreamMapping value: stream ]
		ifNone: [ HTTPClientError signalNotFound ]