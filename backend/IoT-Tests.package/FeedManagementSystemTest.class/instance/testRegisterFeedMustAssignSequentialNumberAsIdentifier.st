test
testRegisterFeedMustAssignSequentialNumberAsIdentifier

	| feed anotherFeed |

	feed := self feedManagementSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	self assert: feed identifier equals: 1.

	anotherFeed := self feedManagementSystem registerFeedNamed: 'Another feed' describedAs: 'Another feed for tests.'.
	self assert: anotherFeed identifier equals: 2