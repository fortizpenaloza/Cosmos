as yet unclassified
nextCommandFromQueueIdentifiedBy: anIdentifier

	^ self commandManagementSystem
		queueIdentifiedBy: anIdentifier asNumber
		ifFound: [:priorityQueue | prioritizedCommandtMapping value: (priorityQueue pop) ]
		ifNone: [ ResourceNotFound signal ]