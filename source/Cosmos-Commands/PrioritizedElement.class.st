Class {
	#name : #PrioritizedElement,
	#superclass : #Object,
	#instVars : [
		'element',
		'priority'
	],
	#category : #'Cosmos-Commands'
}

{ #category : #'instance creation' }
PrioritizedElement class >> holding: anElement with: aPriority [ 
	
	^ self new initializeHolding: anElement with: aPriority
]

{ #category : #accessing }
PrioritizedElement >> element [

	^ element
]

{ #category : #initialization }
PrioritizedElement >> initializeHolding: anElement with: aPriority [

	element := anElement.
	priority := aPriority
]

{ #category : #accessing }
PrioritizedElement >> priority [

	^ priority
]
