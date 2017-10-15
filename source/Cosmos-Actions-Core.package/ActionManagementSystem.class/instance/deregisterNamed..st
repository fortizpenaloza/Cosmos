managing
deregisterNamed: aName

	self
		actionNamed: aName
		ifFound: [ :action | self deregister: action ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Action not found in system' ]