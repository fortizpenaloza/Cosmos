test
testFeedRegistrationFailsWhenIdentifierAlreadyExists

	| feed anotherFeed |

	feed := Feed
		identifiedBy: 1
		named: 'Feed #1'
		describedAs: 'Test feed #1'
		createdOn: self timeSystem dateTime.
	self feedManagementSystem register: feed.
	
	anotherFeed := Feed
		identifiedBy: 1
		named: 'Feed #2'
		describedAs: 'Test feed #2'
		createdOn: self timeSystem dateTime.
	self
		should: [ self feedManagementSystem register: anotherFeed ]
		raise: ObjectAlreadyInSystem
		withDescription: 'Feed already exists in system'