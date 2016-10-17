tests
testDataChannelSuccesfulQuery

	| teapot writer response localTimeString |
	
		writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: DataChannelSnapshot
				do: [ :mapping |
					mapping mapAccessors: #(name dataStreams )];
				for: DataStream 
				do: [ :mapping |
					mapping mapAccessors: #(name currentValue lastUpdate)];
				for: DateTime
				customDo: [ :mapping |
   					mapping encoder: [ :dateTime | dateTime printString ]];
				nextPut: object ] ].	
	
	teapot:= Teapot configure:{	#port -> 8010. 	#debugMode -> true}.
	teapot
			GET: '/dataChannel/<identifier>' -> [ :request | 
				self dataManagementSystem	
					channelIdentifiedBy: (request at: #identifier) asNumber
					ifFound: [:channel| 
						writer value: (DataChannelSnapshot of: channel with: (self dataManagementSystem streamsOf: channel))]
					ifNone: []];
		start.
	
	response:= ZnEasy get: 'http://localhost:8010/dataChannel/', (self identifier asString).

	localTimeString:= TimeZones local asString.
	
	self assert: response code equals: 200.
	self assert: response contents equals: '{"name":"Sensors #1","dataStreams":[{"name":"Temperature","currentValue":16,"lastUpdate":"September 6, 2015 12:00:00 {',localTimeString,'}"},{"name":"Pressure","currentValue":1016,"lastUpdate":"September 6, 2015 12:00:00 {',localTimeString,'}"},{"name":"Humidity","currentValue":72,"lastUpdate":"September 6, 2015 12:00:00 {',localTimeString,'}"}]}'.
	
	teapot stop.