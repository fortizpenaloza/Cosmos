tests
testQueryingStreamByName

	| interface response |

	interface := RESTDataInterface workingWith: rootSystem.
	response := interface streamNamed: 'Temperature'.

	self
		assert: response code equals: 200;
		assert: response body equals: (ZnEntity json: self temperatureDataStreamAsJSON)