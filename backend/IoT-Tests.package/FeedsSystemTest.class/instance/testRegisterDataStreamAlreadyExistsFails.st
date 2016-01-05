test
testRegisterDataStreamAlreadyExistsFails

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
	self
		should: [self feedsSystem register: dataStream to: feed ]
		raise: ObjectAlreadyInSystem  
		withDescription: 'Data stream already exists in system'