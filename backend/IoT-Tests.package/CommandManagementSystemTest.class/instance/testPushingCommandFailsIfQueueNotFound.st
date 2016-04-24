tests
testPushingCommandFailsIfQueueNotFound

	self
		should: [ self commandManagementSystem
				push: 'TURN_ON_LED'
				with: QueuePriority high
				toQueueIdentifiedBy: 1 ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Command queue does not exists in system'