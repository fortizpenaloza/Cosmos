tests
testDataStreamRegistrationFailsIfAlreadyExists

	self dataManagementSystem registerStreamNamed: 'Temperature'.

	self
		should:
			[ self dataManagementSystem registerStreamNamed: 'Temperature' ]
		raise: ObjectAlreadyInSystem
		withDescription: 'A data stream with that name already exists in system'