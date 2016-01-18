test
testQueryFeedByIdentifierFailsIfDoesntExists

	| feed |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
		
	self feedManagementSystem register: feed.
	self
		should: [ self feedManagementSystem feedIdentifiedBy: 2 ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Feed does not exists in system.'