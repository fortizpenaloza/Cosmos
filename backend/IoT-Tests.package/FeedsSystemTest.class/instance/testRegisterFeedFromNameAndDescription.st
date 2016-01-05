test
testRegisterFeedFromNameAndDescription
	
	self assert: self feedsSystem feeds isEmpty.
	
	self feedsSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self feedsSystem feeds isEmpty.	
	self assert: self feedsSystem feeds size equals: 1.
	self assert: self feedsSystem feeds first name equals: 'Feed'.
	self assert: self feedsSystem feeds first description equals: 'Feed for tests'.