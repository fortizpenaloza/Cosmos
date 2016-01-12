test
testQueryFeedByIdentifierDoesntExistsFails

	| feed |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	
	self feedRegistrationSystem register: feed.
	
	self
		should: [self feedRegistrationSystem feedIdentifiedBy: 2]
		raise: ObjectNotFoundInSystem
		withDescription: 'Feed does not exists in system'