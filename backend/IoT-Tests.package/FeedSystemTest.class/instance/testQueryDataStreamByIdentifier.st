test
testQueryDataStreamByIdentifier

	|  dataStream feed |

	feed := self feedSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := DataStream identifiedBy: 'x'.
	
	self feedSystem register: dataStream to: feed.
	
	self assert: (self feedSystem dataStreamIdentifiedBy: 'x' of: feed) equals: dataStream