tests
testQueryingDataStreamsSnapshot

	| interface response |

	interface := DataAPI workingWith: rootSystem.
	response := interface streams.

	self
		assert: response code equals: 200;
		assert: response contents equals: self dataStreamsSnapshotAsJSON