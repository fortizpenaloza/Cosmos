managing
registerChannelNamed: aName

	| dataChannel | 
	
	dataChannel := DataChannel
		identifiedBy: identifierProvider next
		named: aName
		createdOn: timeSystem dateTime.

	self registerChannel: dataChannel.
	
	^ dataChannel 
