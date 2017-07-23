tests
testQueryingDataStreamsSnapshot

	| interface response |

	interface := RESTDataInterface workingWith: rootSystem.
	response := interface	streams.

	self assert: response equals: self dataStreamsSnapshotAsJSON