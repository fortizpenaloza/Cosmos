test
testRegisterFeedMustAssignSequentialNumberAsIdentifier

	| feed anotherFeed |

	self assert: self feedManagementSystem feeds isEmpty.
	feed := self feedManagementSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self feedManagementSystem feeds isEmpty.
	self assert: feed identifier equals: 1.
	
	anotherFeed := self feedManagementSystem
		registerFeedNamed: 'Another feed'
		describedAs: 'Another feed for tests.'.
	
	self assert: anotherFeed identifier equals: 2