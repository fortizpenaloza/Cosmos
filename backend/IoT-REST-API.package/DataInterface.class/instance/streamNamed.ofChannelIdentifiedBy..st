API
streamNamed: aName ofChannelIdentifiedBy: anIdentifier

	^ self dataManagementSystem
		streamNamed: aName
		ofChannelIdentifiedBy: anIdentifier asNumber
		ifFound: [ :stream | 	jsonMapping value: stream ]
		ifNone: [ ResourceNotFound signal ]