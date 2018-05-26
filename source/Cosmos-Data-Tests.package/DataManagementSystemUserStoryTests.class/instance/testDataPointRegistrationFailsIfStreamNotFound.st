tests
testDataPointRegistrationFailsIfStreamNotFound

	self
		should: [ self dataManagementSystem register: 10 toStreamNamed: 'Temperature' ]
		raise: ObjectNotFoundInSystem
		withDescription: 'A data stream with that name does not exists in system'