private-managing
register: anAction

	actions
		detect: [ :action | action name = anAction name ]
		ifFound: [ :action | ObjectAlreadyInSystem signal: 'Action already exists in system' ]
		ifNone: [ actions add: anAction ]