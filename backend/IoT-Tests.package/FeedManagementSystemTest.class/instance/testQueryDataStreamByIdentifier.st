test
testQueryDataStreamByIdentifier

	|  dataStream feed |

	feed := self feedManagementSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := DataStream identifiedBy: 'x'.
	
	self feedManagementSystem register: dataStream to: feed.
	
	self assert: (self feedManagementSystem dataStreamIdentifiedBy: 'x' of: feed) equals: dataStream