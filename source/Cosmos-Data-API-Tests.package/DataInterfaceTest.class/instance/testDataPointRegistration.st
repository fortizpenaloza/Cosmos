tests
testDataPointRegistration

	| interface dataPoint |

	interface := DataInterface workingWith: rootSystem.

	dataPoint := interface
		register: 24
		toStreamNamed: 'Temperature'
		ofChannelIdentifiedBy: self startingIdentifier.
		
	self assert: dataPoint value equals: 24;
		assert: dataPoint timestamp equals: self timeSystem dateTime.

	self dataManagementSystem
		streamNamed: 'Temperature'
		ofChannelIdentifiedBy: self startingIdentifier
		ifFound: [ :stream | self assert: stream dataPoints last equals: dataPoint ]
		ifNone: [ self fail ]