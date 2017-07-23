tests
testQueryingStreamByName

	| interface stream |

	interface := RESTDataInterface workingWith: rootSystem.
	stream := interface streamNamed: 'Temperature'.
	self
		assert: stream
		equals: self streamCalledTemperatureAsJSON