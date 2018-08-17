Class {
	#name : #CommandWithPriority,
	#superclass : #Object,
	#instVars : [
		'command',
		'priority'
	],
	#category : #'Cosmos-Commands'
}

{ #category : #'Instance Creation' }
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

{ #category : #Initialization }
CommandWithPriority >> initializeHolding: aCommand and: aPriority [

	command := aCommand .
	priority := aPriority 
]

{ #category : #Accessing }
CommandWithPriority >> priority [

	^ priority
]
