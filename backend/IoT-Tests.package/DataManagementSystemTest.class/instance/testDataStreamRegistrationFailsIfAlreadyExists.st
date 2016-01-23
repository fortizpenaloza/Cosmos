test
testDataStreamRegistrationFailsIfAlreadyExists
	
	| dataChannel |
	
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	self dataManagementSystem
		registerStreamNamed: 'Temperature'
		toChannelIdentifiedBy: dataChannel identifier.
	
	self
		should: [ self dataManagementSystem
					registerStreamNamed: 'Temperature'
					toChannelIdentifiedBy: dataChannel identifier. ]
		raise: ObjectAlreadyInSystem
		withDescription: 'Data stream already exists in system'