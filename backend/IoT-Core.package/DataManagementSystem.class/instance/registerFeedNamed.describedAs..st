managing
registerFeedNamed: aName describedAs: aDescription
	| feed |
	feed := DataChannel
		identifiedBy: identifierProvider next
		named: aName
		createdOn: self timeSystem dateTime.
	self register: feed.
	^ feed