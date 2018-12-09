Class {
	#name : #Action,
	#superclass : #Object,
	#instVars : [
		'name',
		'evaluationPolicy'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #'instance creation' }
Action class >> named: aName evaluating: anEvaluationPolicy [

	^ self new initializeNamed: aName evaluating: anEvaluationPolicy
]

{ #category : #comparing }
Action >> = anObject [

	^ self == anObject
		or: [ self class = anObject class
				and: [ name = anObject name ] ]
]

{ #category : #evaluation }
Action >> evaluateWith: aConfiguration [

	evaluationPolicy evaluateWith: aConfiguration
]

{ #category : #comparing }
Action >> hash [ 

	^ name hash
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
