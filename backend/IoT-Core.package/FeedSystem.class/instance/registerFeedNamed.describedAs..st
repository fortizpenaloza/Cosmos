managing
registerFeedNamed: aName describedAs: aDescription

	| feed |

	feed := Feed
		identifiedBy: numbering next
		named: aName
		describedAs: aDescription
		createdOn: self timeSystem dateTime.
		
	self register: feed.
	
	^ feed