tests
testQueryingSnapshotOfChannelContainsItsNameAndCurrentValueOfEachDataStream

	| interface response |
	interface :=	RESTDataInterface workingWith: rootSystem.
	response := interface currentSnapshotOfChannelIdentifiedBy: self startingIdentifier asString.
	
	self assert: response equals: self queryingChannelNumber1Answer