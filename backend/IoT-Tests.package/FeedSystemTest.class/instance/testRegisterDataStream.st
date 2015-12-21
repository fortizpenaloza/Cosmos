test
testRegisterDataStream

	| feed dataStream |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'x'.
	
	self assert: self feedSystem feeds isEmpty.
	
	self feedSystem register: feed.
	self feedSystem register: dataStream to: feed.

	self deny: self feedSystem feeds isEmpty.
	self assert: self feedSystem feeds size equals: 1.
	self assert: feed dataStreams size equals: 1