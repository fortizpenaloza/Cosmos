tests
testDataStreamRegistrationFailsIfAlreadyExists

	self dataManagementSystem registerStreamNamed: 'Temperature'.

	self
		should:
			[ self dataManagementSystem registerStreamNamed: 'Temperature' ]
		raise: ObjectAlreadyInSystem
		withDescription: 'Data stream already exists in system'