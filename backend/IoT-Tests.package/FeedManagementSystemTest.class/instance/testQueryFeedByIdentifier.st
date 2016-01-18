test
testQueryFeedByIdentifier

	| identifier feed |

	identifier := 1.
	feed := Feed
		identifiedBy: identifier
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
		
	self feedManagementSystem register: feed.
	self assert: (self feedManagementSystem feedIdentifiedBy: identifier) equals: feed