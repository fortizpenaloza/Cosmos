test
testRegisterFeedMustAssignSequentialNumberAsIdentifier

	| feed anotherFeed |

	self assert: self feedsSystem feeds isEmpty.
	feed := self feedsSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self feedsSystem feeds isEmpty.
	self assert: feed identifier equals: 1.
	
	anotherFeed := self feedsSystem
		registerFeedNamed: 'Another feed'
		describedAs: 'Another feed for tests.'.
	
	self assert: anotherFeed identifier equals: 2