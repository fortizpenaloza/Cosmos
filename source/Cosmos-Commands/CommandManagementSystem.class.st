Class {
	#name : #CommandManagementSystem,
	#superclass : #System,
	#instVars : [
		'timeSystem',
		'priorityQueue',
		'commands',
		'metadataSystem',
		'identifierSystem'
	],
	#category : #'Cosmos-Commands'
}

{ #category : #'system specification' }
CommandManagementSystem class >> implementedInterface [

	^ SystemInterface >> #CommandManagementSystemInterface
]

{ #category : #querying }
CommandManagementSystem >> commands [

	^ commands copy
]

{ #category : #'private - managing' }
CommandManagementSystem >> dequeuedCommand [

	| commandWithPriority |

	commandWithPriority := priorityQueue dequeue.

	[ commands includes: commandWithPriority ]
		whileFalse: [ commandWithPriority := priorityQueue dequeue ].

	^ commandWithPriority
]

{ #category : #managing }
CommandManagementSystem >> deregister: aCommandWithPriority [

	commands remove: aCommandWithPriority
]

{ #category : #initialization }
CommandManagementSystem >> initialize [

	super initialize.
	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	metadataSystem := self unresolvedSystemDependencyTo: #MetadataSystemInterface.
	identifierSystem := self unresolvedSystemDependencyTo: #IdentifierSystemInterface.
	
	commands := OrderedCollection new.
	priorityQueue := PriorityQueue empty
]

{ #category : #managing }
CommandManagementSystem >> nextCommand [

	^ [ commands remove: self dequeuedCommand ]
		on: CollectionIsEmpty
		do: [ :signal | signal signal: 'Command priority queue is empty' ]
]

{ #category : #managing }
CommandManagementSystem >> register: aCommandWithPriority [

	commands add: aCommandWithPriority.
	priorityQueue
		enqueue: aCommandWithPriority
		with: aCommandWithPriority priority.
		
	self registerIdentifierFor: aCommandWithPriority.
	self registerRegistrationTimestampFor: aCommandWithPriority
]

{ #category : #'private - managing' }
CommandManagementSystem >> registerIdentifierFor: aCommandWithPriority [ 

	identifierSystem registerIdentifierFor: aCommandWithPriority
]

{ #category : #'private - managing' }
CommandManagementSystem >> registerRegistrationTimestampFor: aCommandWithPriority [ 

	metadataSystem
		register:
			(Metadata
				attaching: timeSystem dateTime
				as: #registration_timestamp
				of: aCommandWithPriority)
]

{ #category : #'dependency resolution' }
CommandManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.
	metadataSystem := self resolveSystemDependencyTo: #MetadataSystemInterface.
	identifierSystem := self resolveSystemDependencyTo: #IdentifierSystemInterface
]

{ #category : #querying }
CommandManagementSystem >> withCommandIdentifiedBy: anIdentifier do: aBlock [

	^ aBlock
		value:
			(identifierSystem
				objectIdentifiedBy: anIdentifier
				ifNone: [ ObjectNotFound signal: 'Command with that identifier not found' ])
]
