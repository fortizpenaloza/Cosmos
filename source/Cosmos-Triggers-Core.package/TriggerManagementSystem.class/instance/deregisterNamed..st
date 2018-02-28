managing
deregisterNamed: aName

	self
		triggerNamed: aName
		ifFound: [ :trigger | self deregister: trigger accordingTo: trigger triggeringPolicy ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Trigger not found in system' ]