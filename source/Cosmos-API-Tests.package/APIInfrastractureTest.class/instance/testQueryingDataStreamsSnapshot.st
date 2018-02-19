tests
testQueryingDataStreamsSnapshot

	| response |

	response := ZnEasy get: 'http://localhost:8010/data-streams'.

	self
		assert: response code equals: 200;
		assert: response entity equals: (ZnEntity json: self dataStreamsSnapshotAsJSON)