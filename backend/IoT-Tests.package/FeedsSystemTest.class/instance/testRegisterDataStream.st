test
testRegisterDataStream

	| feed dataStream |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'x'.
	
	self assert: self feedsSystem feeds isEmpty.
	
	self feedsSystem register: feed.
	self feedsSystem register: dataStream to: feed.

	self deny: self feedsSystem feeds isEmpty.
	self assert: self feedsSystem feeds size equals: 1.
	self assert: feed dataStreams size equals: 1