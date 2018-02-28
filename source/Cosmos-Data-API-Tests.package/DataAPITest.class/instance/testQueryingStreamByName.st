tests
testQueryingStreamByName

	| interface response |

	interface := DataAPI workingWith: rootSystem.
	response := interface streamNamed: 'Temperature'.

	self
		assert: response code equals: 200;
		assert: response contents equals: self temperatureDataStreamAsJSON