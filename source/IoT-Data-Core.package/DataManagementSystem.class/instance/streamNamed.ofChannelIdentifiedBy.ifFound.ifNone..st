querying
streamNamed: aName ofChannelIdentifiedBy: anIdentifier ifFound: aFoundBlock ifNone: aNoneBlock

	^ dataStreams 	
		detect: [ :dataStream | dataStream name = aName and: [ dataStream dataChannel identifier = anIdentifier ] ]
		ifFound: [ :dataStream | aFoundBlock value: dataStream ]
		ifNone: aNoneBlock