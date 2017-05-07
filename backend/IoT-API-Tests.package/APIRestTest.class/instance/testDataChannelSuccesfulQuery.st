tests
testDataChannelSuccesfulQuery

	| teapot response localTimeString interface|
	
	interface := DataInterface workingWith: rootSystem.
	
	teapot:= Teapot configure:{	#port -> 8010. 	#debugMode -> true}.
	teapot
			GET: '/dataChannel/<identifier>' -> [ :request | 
				self dataManagementSystem	
					channelIdentifiedBy: (request at: #identifier) asNumber
					ifFound: [:channel| 
						interface currentSnapshotOfChannelIdentifiedBy: (request at: #identifier) asNumber]
					ifNone: []];
		start.
	
	response := ZnEasy get: 'http://localhost:8010/dataChannel/', (self identifier asString).

	localTimeString:= TimeZones local asString.
	
	self assert: response code equals: 200.
	self assert: response contents equals: self queryingChannelNumber1Answer.
	
	teapot stop.