test
testRegisterDataStreamAlreadyExistsFails

	| feed dataStream |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'x'.
	
	self assert: self feedRegistrationSystem feeds isEmpty.
	
	self feedRegistrationSystem register: feed.
	self feedRegistrationSystem register: dataStream to: feed.
	
	self deny: self feedRegistrationSystem feeds isEmpty.
	self assert: self feedRegistrationSystem feeds size equals: 1.
	self
		should: [self feedRegistrationSystem register: dataStream to: feed ]
		raise: ObjectAlreadyInSystem  
		withDescription: 'Data stream already exists in system'