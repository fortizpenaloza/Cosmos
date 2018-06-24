Class {
	#name : #BlockEvaluationPolicy,
	#superclass : #ActionEvaluationPolicy,
	#instVars : [
		'block'
	],
	#category : #'Cosmos-Actions-Model'
}

{ #category : #'instance creation' }
BlockEvaluationPolicy class >> for: aBlock [ 

	^ self new initializeFor: aBlock
]

{ #category : #evaluating }
BlockEvaluationPolicy >> evaluateWith: anActionEvaluatorConfiguration [

	block value
]

{ #category : #'initialize-release' }
BlockEvaluationPolicy >> initializeFor: aBlock [

	block := aBlock
]
