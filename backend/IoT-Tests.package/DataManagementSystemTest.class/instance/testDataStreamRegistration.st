test
testDataStreamRegistration

	| dataChannel dataStream |
	
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'
		toChannelIdentifiedBy: dataChannel identifier.

	self
		assert: dataStream name equals: 'Temperature';
		assert: dataStream creationDateTime equals: self timeSystem dateTime;
		assert: dataStream dataChannel equals: dataChannel