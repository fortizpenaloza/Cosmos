managing
registerStreamNamed: aName

	^ self
		streamNamed: aName
		ifFound: [ :dataStream | ObjectAlreadyInSystem signal: 'Data stream already exists in system' ]
		ifNone: [ self registerStream: (DataStream named: aName createdOn: timeSystem dateTime) ]