test
testQueryDataStreamByIdentifier

	|  dataStream feed |

	feed := self feedsSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := DataStream identifiedBy: 'x'.
	
	self feedsSystem register: dataStream to: feed.
	
	self assert: (self feedsSystem dataStreamIdentifiedBy: 'x' of: feed) equals: dataStream