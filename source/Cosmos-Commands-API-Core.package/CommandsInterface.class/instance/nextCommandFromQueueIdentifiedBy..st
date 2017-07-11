querying
nextCommandFromQueueIdentifiedBy: anIdentifier

	^ prioritizedCommandtMapping value: (self commandManagementSystem popFromQueueIdentifiedBy: anIdentifier)