private-managing
registerStream: aDataStream

	self
		streamNamed: aDataStream name
		ofChannelIdentifiedBy: aDataStream dataChannel identifier
		ifFound: [ :dataStream | ObjectAlreadyInSystem signal: 'Data stream already exists in system' ]
		ifNone: [ dataStreams add: aDataStream ]