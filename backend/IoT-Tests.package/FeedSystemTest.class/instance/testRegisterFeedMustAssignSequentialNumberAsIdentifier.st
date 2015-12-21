test
testRegisterFeedMustAssignSequentialNumberAsIdentifier

	| feed anotherFeed |

	self assert: self feedSystem feeds isEmpty.
	feed := self feedSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self feedSystem feeds isEmpty.
	self assert: feed identifier equals: 1.
	
	anotherFeed := self feedSystem
		registerFeedNamed: 'Another feed'
		describedAs: 'Another feed for tests.'.
	
	self assert: anotherFeed identifier equals: 2