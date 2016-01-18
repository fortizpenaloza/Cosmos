test
testRegisterFeedFromNameAndDescription
	
	self assert: self feedManagementSystem feeds isEmpty.
	
	self feedManagementSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self feedManagementSystem feeds isEmpty.	
	self assert: self feedManagementSystem feeds size equals: 1.
	self assert: self feedManagementSystem feeds first name equals: 'Feed'.
	self assert: self feedManagementSystem feeds first description equals: 'Feed for tests'.