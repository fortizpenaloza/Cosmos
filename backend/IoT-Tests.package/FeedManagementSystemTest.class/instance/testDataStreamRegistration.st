test
testDataStreamRegistration

	| feed dataStream |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'x'.
	
	self feedManagementSystem register: feed.
	self feedManagementSystem register: dataStream to: feed.
	
	self assert: feed dataStreams size equals: 1