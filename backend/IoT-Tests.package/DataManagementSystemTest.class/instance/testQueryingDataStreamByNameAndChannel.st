test
testQueryingDataStreamByNameAndChannel
	| dataStream feed |
	feed := self dataManagementSystem registerChannelNamed: 'Feed'.
	dataStream := DataStream identifiedBy: 'x'.
	self dataManagementSystem register: dataStream to: feed.
	self
		assert: (self dataManagementSystem streamNamed: 'x' of: feed)
		equals: dataStream