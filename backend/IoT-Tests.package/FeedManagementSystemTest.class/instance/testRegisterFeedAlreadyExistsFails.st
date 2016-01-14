test
testRegisterFeedAlreadyExistsFails

	| feed |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	
	self assert: self feedRegistrationSystem feeds isEmpty.
	
	self feedRegistrationSystem register: feed.
	
	self deny: self feedRegistrationSystem feeds isEmpty.
	self assert: self feedRegistrationSystem feeds size equals: 1.
	self
		should: [self feedRegistrationSystem register: feed]
		raise: ObjectAlreadyInSystem  
		withDescription: 'Feed already exists in system'