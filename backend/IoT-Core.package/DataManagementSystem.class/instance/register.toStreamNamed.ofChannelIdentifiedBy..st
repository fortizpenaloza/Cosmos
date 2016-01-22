managing
register: aValue toStreamNamed: aName ofChannelIdentifiedBy: anIdentifier

	self channelIdentifiedBy: anIdentifier
		ifFound:
			[ :dataChannel | dataStreams
				detect: [ :dataStream | dataStream dataChannel = dataChannel ]
				ifFound: [ :dataStream | dataStream add: (DataPoint on: timeSystem dateTime holding: aValue) ]
				ifNone: [ ObjectNotFoundInSystem signal: 'Data stream does not exists in system' ] ]
		ifNot: [ ObjectNotFoundInSystem signal: 'Data channel does not exists in system' ]