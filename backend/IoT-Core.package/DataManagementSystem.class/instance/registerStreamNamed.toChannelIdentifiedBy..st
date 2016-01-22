managing
registerStreamNamed: aName toChannelIdentifiedBy: anIdentifier
	
	^ self channelIdentifiedBy: anIdentifier 
		ifFound: [:dataChannel | dataStreams add: (DataStream 
			named: aName 
			createdOn: timeSystem dateTime 
			belongingTo: dataChannel) ] 
		ifNot: [ ObjectNotFoundInSystem signal: 'Data channel does not exists in system'  ]
	
	