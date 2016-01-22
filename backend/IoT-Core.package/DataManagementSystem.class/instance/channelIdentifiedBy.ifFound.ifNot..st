querying
channelIdentifiedBy: anIdentifier ifFound: aFoundBlock ifNot: aNoneBlock

	^ dataChannels 
		detect: [ :dataChannel | dataChannel identifier = anIdentifier ] 
		ifFound: [ :dataChannel | aFoundBlock cull: dataChannel ]
		ifNone: aNoneBlock 