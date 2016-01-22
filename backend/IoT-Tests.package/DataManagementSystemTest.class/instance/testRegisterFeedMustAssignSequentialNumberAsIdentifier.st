test
testRegisterFeedMustAssignSequentialNumberAsIdentifier
	| feed anotherFeed |
	self assert: self dataManagementSystem feeds isEmpty.
	feed := self dataManagementSystem registerChannelNamed: 'Feed'.
	self deny: self dataManagementSystem feeds isEmpty.
	self assert: feed identifier equals: 1.
	anotherFeed := self dataManagementSystem
		registerChannelNamed: 'Another feed'.
	self assert: anotherFeed identifier equals: 2