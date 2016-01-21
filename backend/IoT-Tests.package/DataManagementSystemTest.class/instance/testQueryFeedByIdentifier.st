test
testQueryFeedByIdentifier
	| identifier feed |
	identifier := 1.
	feed := DataChannel
		identifiedBy: identifier
		named: #DataChannel
		createdOn: self timeSystem dateTime.
	self dataManagementSystem register: feed.
	self
		assert: (self dataManagementSystem feedIdentifiedBy: identifier)
		equals: feed