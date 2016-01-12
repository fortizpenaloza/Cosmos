test
testRegisterFeedFromNameAndDescription
	
	self assert: self feedRegistrationSystem feeds isEmpty.
	
	self feedRegistrationSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self feedRegistrationSystem feeds isEmpty.	
	self assert: self feedRegistrationSystem feeds size equals: 1.
	self assert: self feedRegistrationSystem feeds first name equals: 'Feed'.
	self assert: self feedRegistrationSystem feeds first description equals: 'Feed for tests'.