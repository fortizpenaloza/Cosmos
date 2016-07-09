tests
testAnAPIRestImplementationCanAnswerToQuery

	| dataChannel dataStream teapot|
	
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'
		toChannelIdentifiedBy: dataChannel identifier.
		
	self dataManagementSystem
		register: 10
		toStreamNamed: dataStream name
		ofChannelIdentifiedBy: dataChannel identifier.
		
	teapot:= Teapot configure:{	#port -> 8010. 	#debugMode -> true}.
	teapot
			GET: '/dataChannel/<dataChannelId>/dataStream/<dataStreamName>' -> [ :request | self dataManagementSystem	streamNamed: (request at: #dataStreamName) 
		ofChannelIdentifiedBy: (request at: #dataChannelId) asNumber 
		ifFound: [ :dataStreamFound |
			self
				assert: dataStreamFound name equals: (dataStream name);
				assert: dataStreamFound creationDateTime equals: self timeSystem dateTime;
				withTheOnlyOneIn: dataStreamFound dataPoints do:[:dataPoint| self assert: dataPoint value equals: 10.
					self assert: dataPoint timestamp equals: self timeSystem dateTime.] 
				]
		ifNone: [  ] ];
		start.
	
	ZnEasy get: 'http://localhost:8010/dataChannel/', (dataChannel identifier asString) ,'/dataStream/',dataStream name .
	
	teapot stop.