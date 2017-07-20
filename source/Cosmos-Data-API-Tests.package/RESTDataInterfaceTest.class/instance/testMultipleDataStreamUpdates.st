tests
testMultipleDataStreamUpdates

	| interface dataPoints |

	interface := RESTDataInterface workingWith: rootSystem.

	dataPoints := interface
		register: self updateTemperatureAndPressureDataStreamsJSON
		toChannelIdentifiedBy: self startingIdentifier.

	self dataManagementSystem
		streamNamed: 'Temperature'
		ofChannelIdentifiedBy: self startingIdentifier
		ifFound:
			[ :stream | self assert: stream dataPoints last equals: dataPoints first ]
		ifNone: [ self fail ].

	self dataManagementSystem
		streamNamed: 'Pressure'
		ofChannelIdentifiedBy: self startingIdentifier
		ifFound:
			[ :stream | self assert: stream dataPoints last equals: dataPoints second ]
		ifNone: [ self fail ]