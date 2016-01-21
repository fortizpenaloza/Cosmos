test
testRegisterDataPoint
	| feed dataStream |
	feed := DataChannel
		identifiedBy: 1
		named: #DataChannel
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'test'.
	self assert: self dataManagementSystem feeds isEmpty.
	self dataManagementSystem register: feed.
	self dataManagementSystem register: dataStream to: feed.
	self dataManagementSystem register: 10 to: dataStream of: feed.
	self assert: feed dataStreams first dataPoints size equals: 1.
	self assert: feed dataStreams first dataPoints first value equals: 10