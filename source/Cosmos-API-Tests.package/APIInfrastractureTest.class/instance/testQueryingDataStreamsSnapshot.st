tests
testQueryingDataStreamsSnapshot

	| response |

	response := ZnEasy get: 'http://localhost:8010/data-streams'.

	self
		assert: response code equals: 200;
		assert: response contents equals: self dataStreamsSnapshotAsJSON