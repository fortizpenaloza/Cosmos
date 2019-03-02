Class {
	#name : #CommandWithPriority,
	#superclass : #Object,
	#instVars : [
		'command',
		'priority'
	],
	#category : #'Cosmos-Commands'
}

{ #category : #'instance creation' }
CommandWithPriority class >> holding: aCommand and: aPriority [

	^ self new initializeHolding: aCommand and: aPriority
]

{ #category : #comparing }
CommandWithPriority >> = anObject [

	^ self == anObject
		or: [ self class = anObject class
				and: [ command = anObject command and: [ priority = anObject priority ] ] ]
]

{ #category : #accessing }
CommandWithPriority >> command [

	^ command
]

{ #category : #comparing }
CommandWithPriority >> hash [

	^ command hash bitXor: priority hash
]

{ #category : #initialization }
CommandWithPriority >> initializeHolding: aCommand and: aPriority [

	command := aCommand .
	priority := aPriority 
]

{ #category : #printing }
CommandWithPriority >> printOn: aStream [

	aStream
		nextPutAll: ('<1s> [<2p>]' expandMacrosWith: command with: priority)
]

{ #category : #accessing }
CommandWithPriority >> priority [

	^ priority
]
