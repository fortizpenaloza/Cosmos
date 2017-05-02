tests
testQueryingDataStreamByNameAndChannelIdentifier

	| dataChannel |

	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	self dataManagementSystem
		registerStreamNamed: 'Temperature'
		toChannelIdentifiedBy: dataChannel identifier.

	self dataManagementSystem
		streamNamed: 'Temperature'
		ofChannelIdentifiedBy: dataChannel identifier
		ifFound: [ :dataStream | 
			self
				assert: dataStream name equals: 'Temperature';
				assert: dataStream creationDateTime equals: self timeSystem dateTime;
				assert: dataStream dataPoints isEmpty;
				assert: dataStream dataChannel equals: dataChannel ]
		ifNone: [  ]