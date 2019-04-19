Class {
	#name : #ActionEvaluation,
	#superclass : #Object,
	#instVars : [
		'action',
		'evaluationDateTime'
	],
	#category : #'Cosmos-ActionEvaluator'
}

{ #category : #'instance creation' }
ActionEvaluation class >> of: anAction on: aDateTime [ 
	
	^ self new initializeOf: anAction on: aDateTime
]

{ #category : #accessing }
ActionEvaluation >> action [

	^ action
]

{ #category : #accessing }
ActionEvaluation >> evaluationDateTime [

	^ evaluationDateTime
]

{ #category : #initialization }
ActionEvaluation >> initializeOf: anAction on: aDateTime [
	
	action := anAction.
	evaluationDateTime := aDateTime
]
