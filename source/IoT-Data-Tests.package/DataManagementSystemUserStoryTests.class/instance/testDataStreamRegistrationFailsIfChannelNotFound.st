tests
testDataStreamRegistrationFailsIfChannelNotFound

	self
		should: [ self dataManagementSystem
				registerStreamNamed: 'Temperature'
				toChannelIdentifiedBy: self startingIdentifier ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Data channel does not exists in system'