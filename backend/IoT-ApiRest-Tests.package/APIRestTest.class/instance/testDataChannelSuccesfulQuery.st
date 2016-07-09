tests
testDataChannelSuccesfulQuery

	| dataChannel temperatureStream  humidityStream atmosphericPressureStream teapot writer response |
	
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	
	temperatureStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'
		toChannelIdentifiedBy: dataChannel identifier.
		
	atmosphericPressureStream := self dataManagementSystem
		registerStreamNamed: 'Pressure'
		toChannelIdentifiedBy: dataChannel identifier.
	humidityStream := self dataManagementSystem
		registerStreamNamed: 'Humidity'
		toChannelIdentifiedBy: dataChannel identifier.
	
	self dataManagementSystem
		register: 16 
		toStreamNamed: temperatureStream name
		ofChannelIdentifiedBy: dataChannel identifier.
	
	self dataManagementSystem
		register: 1016 
		toStreamNamed: atmosphericPressureStream name
		ofChannelIdentifiedBy: dataChannel identifier.

	self dataManagementSystem
		register: 72 
		toStreamNamed: humidityStream name
		ofChannelIdentifiedBy: dataChannel identifier.

	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: DataChannelCurrentStatus
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
						writer value: (DataChannelCurrentStatus of: channel with: (self dataManagementSystem streamsOfChannel: channel))]
					ifNone: []];
		start.
	
	response:= ZnEasy get: 'http://localhost:8010/dataChannel/', (dataChannel identifier asString).

	self assert: response code equals: 200.
	self assert: response contents equals: '{"name":"Channel #1","dataStreams":[{"name":"Temperature","currentValue":16,"lastUpdate":"September 6, 2015 12:00:00 {(GMT-03:00) Local Time}"},{"name":"Pressure","currentValue":1016,"lastUpdate":"September 6, 2015 12:00:00 {(GMT-03:00) Local Time}"},{"name":"Humidity","currentValue":72,"lastUpdate":"September 6, 2015 12:00:00 {(GMT-03:00) Local Time}"}]}'.
	
	teapot stop.