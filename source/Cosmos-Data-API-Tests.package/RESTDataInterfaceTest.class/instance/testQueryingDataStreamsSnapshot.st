tests
testQueryingDataStreamsSnapshot

	| interface response |

	interface := RESTDataInterface workingWith: rootSystem.
	response := interface streams.

	self
		assert: response code equals: 200;
		assert: response contents equals: self dataStreamsSnapshotAsJSON