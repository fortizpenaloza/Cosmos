managing
deregisterNamed: aName

	actions
		detect: [ :action | action name = aName ]
		ifFound: [ :action | self deregister: action ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Action not found in system' ]