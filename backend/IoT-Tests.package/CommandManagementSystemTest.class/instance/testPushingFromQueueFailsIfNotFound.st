tests
testPushingFromQueueFailsIfNotFound

	self
		should: [ self commandManagementSystem
				push: self turnOnLedCommand
				with: QueuePriority high
				toQueueIdentifiedBy: 1 ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Command queue does not exists in system'