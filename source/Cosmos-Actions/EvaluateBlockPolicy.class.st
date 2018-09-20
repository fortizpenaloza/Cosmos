Class {
	#name : #EvaluateBlockPolicy,
	#superclass : #ActionEvaluationPolicy,
	#instVars : [
		'block'
	],
	#category : #'Cosmos-Actions-Model'
}

{ #category : #'instance creation' }
EvaluateBlockPolicy class >> for: aBlock [ 

	^ self new initializeFor: aBlock
]

{ #category : #evaluating }
EvaluateBlockPolicy >> evaluateWith: anActionEvaluatorConfiguration [

	block value
]

{ #category : #'initialize-release' }
EvaluateBlockPolicy >> initializeFor: aBlock [

	block := aBlock
]
