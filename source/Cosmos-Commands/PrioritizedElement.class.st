Class {
	#name : #PrioritizedElement,
	#superclass : #Object,
	#instVars : [
		'element',
		'priority'
	],
	#category : #'Cosmos-Commands'
}

{ #category : #'Instance Creation' }
PrioritizedElement class >> holding: anElement with: aPriority [ 
	
	^ self new initializeHolding: anElement with: aPriority
]

{ #category : #Accessing }
PrioritizedElement >> element [

	^ element
]

{ #category : #Initialization }
PrioritizedElement >> initializeHolding: anElement with: aPriority [

	element := anElement.
	priority := aPriority
]

{ #category : #Accessing }
PrioritizedElement >> priority [

	^ priority
]
