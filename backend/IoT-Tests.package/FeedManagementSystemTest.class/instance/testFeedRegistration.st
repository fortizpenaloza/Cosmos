test
testFeedRegistration

	| feed registeredFeed |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	
	self feedManagementSystem register: feed.
	registeredFeed := self feedManagementSystem feedIdentifiedBy: 1.
	
	self assert: feed identifier equals: registeredFeed identifier;
		assert: feed name equals: registeredFeed name;
		assert: feed description equals: registeredFeed description;
		assert: feed creationDateTime equals: registeredFeed creationDateTime.
	