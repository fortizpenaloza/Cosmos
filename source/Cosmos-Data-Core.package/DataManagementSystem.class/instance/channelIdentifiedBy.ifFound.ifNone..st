querying
channelIdentifiedBy: anIdentifier ifFound: aFoundBlock ifNone: aNoneBlock

	^ dataChannels 
		detect: [ :dataChannel | dataChannel identifier = anIdentifier ] 
		ifFound: [ :dataChannel | aFoundBlock value: dataChannel ]
		ifNone: aNoneBlock 