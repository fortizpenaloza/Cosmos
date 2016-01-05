test
testQueryFeedByIdentifier

	| identifier feed |

	identifier := 1.
	feed := Feed
		identifiedBy: identifier
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
		
	self feedsSystem register: feed.
	self assert: (self feedsSystem feedIdentifiedBy: identifier) equals: feed