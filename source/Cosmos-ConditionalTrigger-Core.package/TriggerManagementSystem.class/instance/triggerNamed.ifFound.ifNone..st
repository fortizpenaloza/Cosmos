private-querying
triggerNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock

	^ triggers
		detect: [ :trigger | trigger name = aName ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock