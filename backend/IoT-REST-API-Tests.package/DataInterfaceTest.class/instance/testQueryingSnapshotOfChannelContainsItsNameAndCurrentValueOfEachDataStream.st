tests
testQueryingSnapshotOfChannelContainsItsNameAndCurrentValueOfEachDataStream

	| interface response |
	interface :=	DataInterface workingWith: rootSystem.
	response := interface currentSnapshotOfChannelIdentifiedBy: self identifier asString.
	
	self assert: response equals: self queryingChannelNumber1Answer