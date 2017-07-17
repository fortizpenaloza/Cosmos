managing
unregisterNamed: aName

	actions
		detect: [ :action | action name = aName ]
		ifFound: [ :action | actions remove: action ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Action not found in system' ]