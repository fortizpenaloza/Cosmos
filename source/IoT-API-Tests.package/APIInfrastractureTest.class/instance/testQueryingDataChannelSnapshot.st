tests
testQueryingDataChannelSnapshot

	| response |

	response := ZnEasy get: 'http://localhost:8010/data-channel/' , self startingIdentifier asString.

	self
		assert: response code equals: 200;
		assert: response contents equals: self queryingChannelNumber1Answer