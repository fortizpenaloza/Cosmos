test
testRegisterFeedMustAssignSequentialNumberAsIdentifier

	| feed anotherFeed |

	self assert: self feedRegistrationSystem feeds isEmpty.
	feed := self feedRegistrationSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self feedRegistrationSystem feeds isEmpty.
	self assert: feed identifier equals: 1.
	
	anotherFeed := self feedRegistrationSystem
		registerFeedNamed: 'Another feed'
		describedAs: 'Another feed for tests.'.
	
	self assert: anotherFeed identifier equals: 2