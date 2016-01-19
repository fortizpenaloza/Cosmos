test
testFeedRegistrationFromNameAndDescription
	
	| feed |
	
	self feedManagementSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	feed := self feedManagementSystem feedIdentifiedBy: 1.
	
	self assert: feed identifier equals: 1;
		assert: feed name equals: 'Feed';
		assert: feed description equals: 'Feed for tests';
		assert: feed creationDateTime equals: self timeSystem dateTime 