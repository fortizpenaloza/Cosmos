tests
testPoppingFromQueueFailsIfNotFound

	self
		should: [ self commandManagementSystem popFromQueueIdentifiedBy: 1 ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Command queue does not exists in system'