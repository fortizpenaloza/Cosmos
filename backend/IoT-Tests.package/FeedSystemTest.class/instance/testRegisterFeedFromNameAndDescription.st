test
testRegisterFeedFromNameAndDescription
	
	self assert: self feedSystem feeds isEmpty.
	
	self feedSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self feedSystem feeds isEmpty.	
	self assert: self feedSystem feeds size equals: 1.
	self assert: self feedSystem feeds first name equals: 'Feed'.
	self assert: self feedSystem feeds first description equals: 'Feed for tests'.