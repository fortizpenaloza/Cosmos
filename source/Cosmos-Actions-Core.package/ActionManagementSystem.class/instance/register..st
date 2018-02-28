private-managing
register: anAction

	actions
		detect: [ :action | action name = anAction name ]
		ifFound: [ :action | ObjectAlreadyInSystem signal: 'An action with that name already exists in system' ]
		ifNone: [ actions add: anAction ]