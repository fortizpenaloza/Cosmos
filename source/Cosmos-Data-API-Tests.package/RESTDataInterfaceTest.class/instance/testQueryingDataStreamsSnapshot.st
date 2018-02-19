tests
testQueryingDataStreamsSnapshot

	| interface response |

	interface := RESTDataInterface workingWith: rootSystem.
	response := interface streams.

	self
		assert: response code equals: 200;
		assert: response body equals: (ZnEntity json: self dataStreamsSnapshotAsJSON)