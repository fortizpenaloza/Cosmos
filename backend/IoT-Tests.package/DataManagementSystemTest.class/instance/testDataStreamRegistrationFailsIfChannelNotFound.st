test
testDataStreamRegistrationFailsIfChannelNotFound

	self
		should: [ self dataManagementSystem registerStreamNamed: 'Temperature' toChannelIdentifiedBy: 1 ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Data channel does not exists in system'