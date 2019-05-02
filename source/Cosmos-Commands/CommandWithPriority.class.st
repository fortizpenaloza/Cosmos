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
CommandWithPriority class >> assertIsInteger: aPriority [

	AssertionChecker
		enforce: [ aPriority isInteger ]
		because: [ 'A command''s priority must be an integer' ]
		raising: InstanceCreationFailed
]

{ #category : #'instance creation' }
CommandWithPriority class >> holding: aCommand and: aPriority [

	self assertIsInteger: aPriority.

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
