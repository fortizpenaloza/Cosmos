Class {
	#name : #ActionEvaluatedEvent,
	#superclass : #NotifiableEvent,
	#instVars : [
		'action'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #'instance creation' }
ActionEvaluatedEvent class >> for: anAction [ 
	
	^ self new initializeFor: anAction
]

{ #category : #initialization }
ActionEvaluatedEvent >> initializeFor: anAction [ 
	
	action := anAction 
]
