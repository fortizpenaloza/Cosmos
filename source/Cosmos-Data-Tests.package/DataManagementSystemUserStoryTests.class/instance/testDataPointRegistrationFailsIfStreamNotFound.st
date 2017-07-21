tests
testDataPointRegistrationFailsIfStreamNotFound

	self
		should:
			[ self dataManagementSystem register: 10 toStreamNamed: 'Temperature' ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Data stream does not exists in system'