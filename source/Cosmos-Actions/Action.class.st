Class {
	#name : #Action,
	#superclass : #Object,
	#instVars : [
		'name',
		'evaluationPolicy'
	],
	#category : #'Cosmos-Actions-Model'
}

{ #category : #'instance creation' }
Action class >> named: aName evaluating: anEvaluationPolicy [

	^ self new initializeNamed: aName evaluating: anEvaluationPolicy
]

{ #category : #evaluation }
Action >> evaluateWith: aConfiguration [

	evaluationPolicy evaluateWith: aConfiguration
]

{ #category : #initialization }
Action >> initializeNamed: aName evaluating: anEvaluationPolicy [ 

	name := aName.
	evaluationPolicy := anEvaluationPolicy
]

{ #category : #initialization }
Action >> name [

	^ name
]
