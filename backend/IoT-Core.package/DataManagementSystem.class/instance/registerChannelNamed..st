managing
registerChannelNamed: aName

	| dataChannel |
	
	dataChannel := DataChannel
		identifiedBy: identifierProvider next
		named: aName
		createdOn: self timeSystem dateTime.
	self register: dataChannel.
	^ dataChannel