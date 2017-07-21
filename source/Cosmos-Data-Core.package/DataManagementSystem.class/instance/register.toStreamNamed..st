managing
register: aValue toStreamNamed: aName

	| dataPoint |

	dataPoint := DataPoint on: timeSystem dateTime holding: aValue.

	self
		streamNamed: aName
		ifFound: [ :dataStream | self registerPoint: dataPoint to: dataStream ]
		ifNone: [ ObjectNotFoundInSystem
				signal: 'Data stream does not exists in system' ].

	^ dataPoint