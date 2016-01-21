test
testRegisterFeedMustAssignSequentialNumberAsIdentifier

	| feed anotherFeed |

	self assert: self dataManagementSystem feeds isEmpty.
	feed := self dataManagementSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	
	self deny: self dataManagementSystem feeds isEmpty.
	self assert: feed identifier equals: 1.
	
	anotherFeed := self dataManagementSystem
		registerFeedNamed: 'Another feed'
		describedAs: 'Another feed for tests.'.
	
	self assert: anotherFeed identifier equals: 2