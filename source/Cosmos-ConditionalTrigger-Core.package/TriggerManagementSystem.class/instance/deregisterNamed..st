managing
deregisterNamed: aName

	self
		triggerNamed: aName
		ifFound: [ :trigger | self deregister: trigger ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Trigger not found in system' ]