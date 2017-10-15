querying
actionNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock 

	actions
		detect: [ :action | action name = aName ]
		ifFound: [ :action | aFoundBlock value: action ]
		ifNone: aNoneBlock 