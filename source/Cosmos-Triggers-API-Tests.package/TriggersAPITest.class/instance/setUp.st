initialization
setUp

	| setTriggeredToTrue |

	super setUp.

	interface := TriggersAPI workingWith: (TriggersAPIContext workingWith: rootSystem).

	(SensorsSampleAddOn on: rootSystem) install.

	setTriggeredToTrue := self actionManagementSystem
		registerNamed: 'Set triggered to true'
		toEvaluate: (BlockEvaluationPolicy for: [ "Do nothing" ])