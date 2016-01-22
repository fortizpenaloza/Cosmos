managing-private
register: aDataChannel

	^ self
		channelIdentifiedBy: aDataChannel identifier 
		ifFound: [ :dataChannel | ObjectAlreadyInSystem signal: 'Data channel already exists in system' ]
		ifNot: [ dataChannels add: aDataChannel ]