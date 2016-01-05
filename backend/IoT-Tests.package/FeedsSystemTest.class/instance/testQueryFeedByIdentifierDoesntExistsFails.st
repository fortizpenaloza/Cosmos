test
testQueryFeedByIdentifierDoesntExistsFails

	| feed |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	
	self feedsSystem register: feed.
	
	self
		should: [self feedsSystem feedIdentifiedBy: 2]
		raise: ObjectNotFoundInSystem
		withDescription: 'Feed does not exists in system'