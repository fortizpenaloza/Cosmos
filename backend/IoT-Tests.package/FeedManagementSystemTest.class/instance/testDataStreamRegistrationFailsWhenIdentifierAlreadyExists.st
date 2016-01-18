test
testDataStreamRegistrationFailsWhenIdentifierAlreadyExists

	| feed dataStream |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'x'.

	self feedManagementSystem register: feed.
	self feedManagementSystem register: dataStream to: feed.
	
	self
		should: [self feedManagementSystem register: dataStream to: feed ]
		raise: ObjectAlreadyInSystem  
		withDescription: 'Data stream already exists in system'