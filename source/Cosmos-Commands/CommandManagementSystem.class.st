Class {
	#name : #CommandManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'priorityQueue',
		'commands'
	],
	#category : #'Cosmos-Commands'
}

{ #category : #querying }
CommandManagementSystem >> commandIdentifiedBy: anIdentifier [

	^ self identifierSystem
		objectIdentifiedBy: anIdentifier
		ifNone: [ ObjectNotFound signal: 'Command with that identifier not found' ]
]

{ #category : #querying }
CommandManagementSystem >> commands [

	^ commands copy
]

{ #category : #installing }
CommandManagementSystem >> dependencies [

	^ #(#TimestampingSystemInterface #IdentifierSystemInterface)
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

{ #category : #'private - systems' }
CommandManagementSystem >> identifierSystem [

	^ self >> #IdentifierSystemInterface
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
CommandManagementSystem >> nextCommand [

	^ [ commands remove: self dequeuedCommand ]
		on: CollectionIsEmpty
		do: [ :signal | ObjectNotFound signal: 'Command not found' ]
]

{ #category : #querying }
CommandManagementSystem >> prioritizedCommands [

	^ priorityQueue enqueuedElements 
]

{ #category : #managing }
CommandManagementSystem >> register: aCommandWithPriority [

	commands add: aCommandWithPriority.
	priorityQueue
		enqueue: aCommandWithPriority
		with: aCommandWithPriority priority.
		
	self registerIdentifierFor: aCommandWithPriority.
	self registerTimestampFor: aCommandWithPriority.
	
	^ aCommandWithPriority 
]

{ #category : #'private - managing' }
CommandManagementSystem >> registerIdentifierFor: aCommandWithPriority [ 

	self identifierSystem registerIdentifierFor: aCommandWithPriority
]

{ #category : #'private - managing' }
CommandManagementSystem >> registerTimestampFor: aCommandWithPriority [

	self timestampingSystem registerModificationFor: aCommandWithPriority
]

{ #category : #'private - systems' }
CommandManagementSystem >> timestampingSystem [

	^ self >> #TimestampingSystemInterface
]
