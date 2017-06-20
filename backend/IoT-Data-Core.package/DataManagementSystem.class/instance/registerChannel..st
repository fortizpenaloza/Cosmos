private-managing
registerChannel: aDataChannel

	self
		channelIdentifiedBy: aDataChannel identifier 
		ifFound: [ :dataChannel | ObjectAlreadyInSystem signal: 'Data channel already exists in system' ]
		ifNone: [ dataChannels add: aDataChannel ]