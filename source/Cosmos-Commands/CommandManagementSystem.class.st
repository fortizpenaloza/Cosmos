Class {
	#name : #CommandManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'timeSystem',
		'priorityQueue',
		'commands',
		'metadataSystem',
		'identifierSystem'
	],
	#category : #'Cosmos-Commands'
}

{ #category : #querying }
CommandManagementSystem >> commandIdentifiedBy: anIdentifier [

	^ identifierSystem
		objectIdentifiedBy: anIdentifier
		ifNone: [ ObjectNotFound signal: 'Command with that identifier not found' ]
]

{ #category : #querying }
CommandManagementSystem >> commands [

	^ commands copy
]

{ #category : #installing }
CommandManagementSystem >> dependencies [

	^ #(#TimeSystemInterface #MetadataSystemInterface #IdentifierSystemInterface)
]

{ #category : #managing }
CommandManagementSystem >> dequeueCommand [

	^ [ commands remove: self dequeuedCommand ]
		on: CollectionIsEmpty
		do: [ :signal | ObjectNotFound signal: 'Command not found' ]
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

{ #category : #installing }
CommandManagementSystem >> implementedInterfaces [

	^ #(#CommandManagementSystemInterface)
]

{ #category : #initialization }
CommandManagementSystem >> initialize [

	super initialize.
	commands := OrderedCollection new.
	priorityQueue := PriorityQueue empty
]

{ #category : #accessing }
CommandManagementSystem >> name [ 
	
	^ 'Command Management'
]

{ #category : #managing }
CommandManagementSystem >> register: aCommandWithPriority [

	commands add: aCommandWithPriority.
	priorityQueue
		enqueue: aCommandWithPriority
		with: aCommandWithPriority priority.
		
	self registerIdentifierFor: aCommandWithPriority.
	self registerRegistrationTimestampFor: aCommandWithPriority.
	
	^ aCommandWithPriority 
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
