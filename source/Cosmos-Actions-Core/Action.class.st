Class {
	#name : #Action,
	#superclass : #Object,
	#instVars : [
		'name',
		'creationDateTime',
		'evaluationPolicy'
	],
	#category : 'Cosmos-Actions-Core-Model'
}

{ #category : #'instance creation' }
Action class >> named: aName createdOn: aDateTime toEvaluate: anEvaluationPolicy [ 

	^ self new initializeNamed: aName created: aDateTime toEvaluate: anEvaluationPolicy
]

{ #category : #accessing }
Action >> creationDateTime [

	^ creationDateTime
]

{ #category : #evaluation }
Action >> evaluateWith: aConfiguration [

	evaluationPolicy evaluateWith: aConfiguration
]

{ #category : #initialization }
Action >> initializeNamed: aName created: aDateTime toEvaluate: anEvaluationPolicy [ 

	name := aName.
	creationDateTime := aDateTime.
	evaluationPolicy := anEvaluationPolicy
]

{ #category : #initialization }
Action >> name [

	^ name
]
