querying
streamNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock

	^ dataStreams 	
		detect: [ :dataStream | dataStream name = aName ]
		ifFound: [ :dataStream | aFoundBlock value: dataStream ]
		ifNone: aNoneBlock