test
testRegisterFeedAlreadyExistsFails

	| feed |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	
	self assert: self feedSystem feeds isEmpty.
	
	self feedSystem register: feed.
	
	self deny: self feedSystem feeds isEmpty.
	self assert: self feedSystem feeds size equals: 1.
	self
		should: [self feedSystem register: feed]
		raise: ObjectAlreadyInSystem  
		withDescription: 'Feed already exists in system'