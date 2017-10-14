tests
testDataStreamsUpdate

	| interface dataPoints |

	interface := RESTDataInterface workingWith: rootSystem.

	dataPoints := interface register: self updateTemperatureAndPressureDataStreamsJSON.

	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :stream | self assert: stream dataPoints first equals: dataPoints first ]
		ifNone: [ self fail ].

	self dataManagementSystem
		streamNamed: 'Pressure'
		ifFound: [ :stream | self assert: stream dataPoints first equals: dataPoints last ]
		ifNone: [ self fail ]