tests support
registerDataStreamTo: aDataChannel

	^ self dataManagementSystem
		registerStreamNamed: 'Temperature'
		toChannelIdentifiedBy: aDataChannel identifier