test
testRegisterFeed
	| feed |
	feed := DataChannel
		identifiedBy: 1
		named: #DataChannel
		createdOn: self timeSystem dateTime.
	self assert: self dataManagementSystem feeds isEmpty.
	self dataManagementSystem register: feed.
	self deny: self dataManagementSystem feeds isEmpty.
	self assert: self dataManagementSystem feeds size equals: 1