managing
register: aValue toStreamNamed: aName ofChannelIdentifiedBy: anIdentifier

	| dataPoint |
	
	dataPoint := DataPoint on: timeSystem dateTime holding: aValue.

	self
		streamNamed: aName
		ofChannelIdentifiedBy: anIdentifier
		ifFound: [ :dataStream | self registerPoint: dataPoint to: dataStream ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Data stream does not exists in system' ].
		
	^ dataPoint 