Class {
	#name : #CommandManagementSystem,
	#superclass : #System,
	#instVars : [
		'timeSystem',
		'prioritizedCommands',
		'priorityQueue'
	],
	#category : #'Cosmos-Commands-SystemModel'
}

{ #category : #'system specification' }
CommandManagementSystem class >> implementedInterface [

	^ SystemInterface >> #CommandManagementSystemInterface
]

{ #category : #managing }
CommandManagementSystem >> dequeue [

	^ [ | prioritizedCommand |
			prioritizedCommand := priorityQueue dequeue.
			self unregister: prioritizedCommand.
			prioritizedCommand ]
		on: QueueIsEmpty
		do: [ :signal | signal signal: 'Command priority queue is empty' ]
]

{ #category : #managing }
CommandManagementSystem >> enqueue: aCommand with: aPriority [

	| prioritizedCommand |

	prioritizedCommand := PrioritizedCommand
		holding: aCommand
		with: aPriority
		on: timeSystem dateTime.
		
	priorityQueue enqueue: prioritizedCommand with: aPriority.

	self register: prioritizedCommand.

	^ prioritizedCommand 
]

{ #category : #initialization }
CommandManagementSystem >> initialize [

	super initialize.
	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.

	prioritizedCommands := OrderedCollection new.
	priorityQueue := PriorityQueue empty
]

{ #category : #querying }
CommandManagementSystem >> prioritizedCommands [

	^ prioritizedCommands copy
]

{ #category : #'private-managing' }
CommandManagementSystem >> register: aPrioritizedCommand [

	prioritizedCommands add: aPrioritizedCommand
]

{ #category : #'dependency resolution' }
CommandManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface
]

{ #category : #'private-managing' }
CommandManagementSystem >> unregister: aPrioritizedCommand [

	prioritizedCommands remove: aPrioritizedCommand 
]
