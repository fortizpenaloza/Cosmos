test
testQueryDataStreamByIdentifier

	|  dataStream feed |

	feed := self dataManagementSystem registerFeedNamed: 'Feed' describedAs: 'Feed for tests'.
	dataStream := DataStream identifiedBy: 'x'.
	
	self dataManagementSystem register: dataStream to: feed.
	
	self assert: (self dataManagementSystem dataStreamIdentifiedBy: 'x' of: feed) equals: dataStream