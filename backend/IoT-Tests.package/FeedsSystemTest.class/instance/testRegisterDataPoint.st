test
testRegisterDataPoint

	| feed dataStream |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'test'.
	
	self assert: self feedsSystem feeds isEmpty.
	
	self feedsSystem register: feed.
	self feedsSystem register: dataStream to: feed.
	self feedsSystem register: 10 to: dataStream of: feed.
	
	self assert: feed dataStreams first dataPoints size equals: 1.
	self assert: feed dataStreams first dataPoints first value equals: 10.