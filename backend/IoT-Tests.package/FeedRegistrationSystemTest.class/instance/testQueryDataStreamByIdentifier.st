test
testQueryDataStreamByIdentifier

	|  dataStream feed |

	feed := self feedRegistrationSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := DataStream identifiedBy: 'x'.
	
	self feedRegistrationSystem register: dataStream to: feed.
	
	self assert: (self feedRegistrationSystem dataStreamIdentifiedBy: 'x' of: feed) equals: dataStream