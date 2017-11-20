querying
actionNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock 

	actions
		detect: [ :action | action name = aName ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock 