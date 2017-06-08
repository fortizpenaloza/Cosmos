tests
testDataStreamRegistrationFailsIfChannelNotFound

	self
		should: [ self dataManagementSystem
				registerStreamNamed: 'Temperature'
				toChannelIdentifiedBy: self identifier ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Data channel does not exists in system'