managing
registerFeedNamed: aName describedAs: aDescription

	| feed |

	feed := Feed
		identifiedBy: identifierProvider next
		named: aName
		describedAs: aDescription
		createdOn: timeSystem dateTime.
		
	self register: feed.
	
	^ feed