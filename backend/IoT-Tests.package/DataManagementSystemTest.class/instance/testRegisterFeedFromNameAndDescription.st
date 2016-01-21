test
testRegisterFeedFromNameAndDescription
	
	self assert: self dataManagementSystem feeds isEmpty.
	
	self dataManagementSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self dataManagementSystem feeds isEmpty.	
	self assert: self dataManagementSystem feeds size equals: 1.
	self assert: self dataManagementSystem feeds first name equals: 'Feed'.
	self assert: self dataManagementSystem feeds first description equals: 'Feed for tests'.