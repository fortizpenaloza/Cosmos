test
testQueryFeedByIdentifierDoesntExistsFails
	| feed |
	feed := DataChannel
		identifiedBy: 1
		named: #DataChannel
		createdOn: self timeSystem dateTime.
	self dataManagementSystem register: feed.
	self
		should: [ self dataManagementSystem feedIdentifiedBy: 2 ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Feed does not exists in system.'