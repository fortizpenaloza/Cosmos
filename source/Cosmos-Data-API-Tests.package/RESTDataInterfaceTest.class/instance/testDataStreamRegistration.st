tests
testDataStreamRegistration

	| interface dataStream |

	interface := RESTDataInterface workingWith: rootSystem.

	dataStream := interface registerStreamNamed: 'pH'.

	self
		assert: dataStream name equals: 'pH';
		assert: dataStream creationDateTime equals: self timeSystem dateTime;
		assert: dataStream dataPoints isEmpty