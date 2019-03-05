Class {
	#name : #ActionEvaluatedEvent,
	#superclass : #NotifiableEvent,
	#instVars : [
		'action',
		'evaluationDateTime'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #'instance creation' }
ActionEvaluatedEvent class >> of: anAction on: aDateTime [ 
	
	^ self new initializeOf: anAction on: aDateTime
]

{ #category : #accessing }
ActionEvaluatedEvent >> action [

	^ action
]

{ #category : #accessing }
ActionEvaluatedEvent >> evaluationDateTime [

	^ evaluationDateTime
]

{ #category : #initialization }
ActionEvaluatedEvent >> initializeOf: anAction on: aDateTime [
	
	action := anAction.
	evaluationDateTime := aDateTime
]
