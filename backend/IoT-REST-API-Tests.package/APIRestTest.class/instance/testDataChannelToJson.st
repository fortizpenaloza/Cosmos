tests
testDataChannelToJson

	| writer dataChannel dataStream currentStatus |
	
	dataChannel := DataChannel identifiedBy: 1 named: 'Channel #1' createdOn: (September sixth , 2015) atNoon.
	dataStream := DataStream 
		named: 'Temperature' 
		createdOn: (September sixth , 2015)
		belongingTo: dataChannel.
	dataStream add: (DataPoint on:  (October second, 2015) atMidnight holding: 10).

	currentStatus:= DataChannelSnapshot of: dataChannel with: (OrderedCollection with: dataStream).

	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: DataChannelSnapshot
				 do: [ :mapping |
					mapping mapAccessors: #(name dataStreams )];
				for: DataStream 
				 do: [ :mapping |
					mapping mapAccessors: #(currentValue)];  
				nextPut: object ] ].
		
	self assert: (writer value: currentStatus) equals: '{"name":"Channel #1","dataStreams":[{"currentValue":10}]}'.