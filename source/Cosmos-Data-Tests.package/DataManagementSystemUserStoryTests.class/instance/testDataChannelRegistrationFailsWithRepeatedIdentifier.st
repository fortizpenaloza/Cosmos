tests
testDataChannelRegistrationFailsWithRepeatedIdentifier

	self dataManagementSystem registerChannelNamed: 'Channel #1'.
	self 
		should: [ self dataManagementSystem registerChannelNamed: 'Channel #2' ]
		raise: ObjectAlreadyInSystem 
		withDescription: 'Data channel already exists in system'