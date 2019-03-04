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

{ #category : #accessing }
CommandWithPriority >> command [

	^ command
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
