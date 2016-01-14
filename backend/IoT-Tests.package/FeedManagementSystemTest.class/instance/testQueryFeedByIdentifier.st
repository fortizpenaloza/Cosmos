test
testQueryFeedByIdentifier

	| identifier feed |

	identifier := 1.
	feed := Feed
		identifiedBy: identifier
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
		
	self feedRegistrationSystem register: feed.
	self assert: (self feedRegistrationSystem feedIdentifiedBy: identifier) equals: feed