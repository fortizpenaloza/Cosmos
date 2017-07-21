tests
testQueryingDataStream

	| response |

	response := ZnEasy
		get: 'http://localhost:8010/data-streams/Temperature'.

	self
		assert: response code equals: 200;
		assert: response contents equals: self queryingStreamCalledTemperatureBelongingToChannelNumber1Answer