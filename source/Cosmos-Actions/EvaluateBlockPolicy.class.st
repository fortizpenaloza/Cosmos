Class {
	#name : #EvaluateBlockPolicy,
	#superclass : #ActionEvaluationPolicy,
	#instVars : [
		'block'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #'instance creation' }
EvaluateBlockPolicy class >> for: aBlock [ 

	^ self new initializeFor: aBlock
]

{ #category : #evaluating }
EvaluateBlockPolicy >> evaluateWithin: anEvaluationContext [

	block value
]

{ #category : #initialization }
EvaluateBlockPolicy >> initializeFor: aBlock [

	block := aBlock
]
