test
testQueryFeedByIdentifier

	| identifier feed |

	identifier := 1.
	feed := Feed
		identifiedBy: identifier
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
		
	self feedSystem register: feed.
	self assert: (self feedSystem feedIdentifiedBy: identifier) equals: feed