test
testRegisterFeedAlreadyExistsFails

	| feed |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	
	self assert: self feedsSystem feeds isEmpty.
	
	self feedsSystem register: feed.
	
	self deny: self feedsSystem feeds isEmpty.
	self assert: self feedsSystem feeds size equals: 1.
	self
		should: [self feedsSystem register: feed]
		raise: ObjectAlreadyInSystem  
		withDescription: 'Feed already exists in system'