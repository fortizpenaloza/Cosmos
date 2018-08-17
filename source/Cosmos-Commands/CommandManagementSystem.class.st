Class {
	#name : #CommandManagementSystem,
	#superclass : #System,
	#instVars : [
		'timeSystem',
		'priorityQueue',
		'commands'
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

{ #category : #'private-managing' }
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
		with: aCommandWithPriority priority
]

{ #category : #'dependency resolution' }
CommandManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface
]
