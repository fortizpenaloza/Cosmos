test
testQueryingDataChannelByIdentifier

	| dataChannel |
	
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	
	self dataManagementSystem 
		channelIdentifiedBy: dataChannel identifier 
		ifFound: [ :foundDataChannel | 
			self assert: foundDataChannel identifier equals: dataChannel identifier;
				assert: foundDataChannel name equals: dataChannel name;
				assert: foundDataChannel creationDateTime equals: dataChannel creationDateTime ]
		ifNone: [ ]