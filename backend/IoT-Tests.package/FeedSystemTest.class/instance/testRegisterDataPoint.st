test
testRegisterDataPoint

	| feed dataStream |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'test'.
	
	self assert: self feedSystem feeds isEmpty.
	
	self feedSystem register: feed.
	self feedSystem register: dataStream to: feed.
	self feedSystem register: 10 to: dataStream of: feed.
	
	self assert: feed dataStreams first dataPoints size equals: 1.
	self assert: feed dataStreams first dataPoints first value equals: 10.