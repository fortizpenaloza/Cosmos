managing
registerStreamNamed: aName

	^ self
		streamNamed: aName
		ifFound: [ :dataStream | ObjectAlreadyInSystem signal: 'A data stream with that name already exists in system' ]
		ifNone: [ self registerStream: (DataStream named: aName createdOn: timeSystem dateTime) ]