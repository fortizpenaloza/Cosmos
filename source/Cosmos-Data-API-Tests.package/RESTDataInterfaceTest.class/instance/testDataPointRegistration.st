tests
testDataPointRegistration

	| interface dataPoint |

	interface := RESTDataInterface workingWith: rootSystem.

	dataPoint := interface register: 24 toStreamNamed: 'Temperature'.

	self
		assert: dataPoint value equals: 24;
		assert: dataPoint timestamp equals: self timeSystem dateTime.

	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :stream | self assert: stream dataPoints last equals: dataPoint ]
		ifNone: [ self fail ]