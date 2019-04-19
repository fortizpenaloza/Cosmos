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
Action class >> named: aName doing: anEvaluationPolicy [
	
	^self new initializeNamed: aName doing: anEvaluationPolicy
]

{ #category : #'instance creation' }
Action class >> named: aName evaluating: aBlock [

	^ self named: aName doing: (EvaluateBlockPolicy for: aBlock)
]

{ #category : #'instance creation' }
Action class >> named: aName sending: anHttpRequest [

	^ self named: aName doing: (SendHttpRequestPolicy sending: anHttpRequest)
]

{ #category : #comparing }
Action >> = anObject [

	^ self == anObject
		or: [ self class = anObject class
				and: [ name = anObject name ] ]
]

{ #category : #evaluation }
Action >> evaluateWithin: anEvaluationContext [

	evaluationPolicy evaluateWithin: anEvaluationContext
]

{ #category : #comparing }
Action >> hash [ 

	^ name hash
]

{ #category : #initialization }
Action >> initializeNamed: aName doing: anEvaluationPolicy [ 

	name := aName.
	evaluationPolicy := anEvaluationPolicy
]

{ #category : #initialization }
Action >> name [

	^ name
]

{ #category : #printing }
Action >> printOn: aStream [

	aStream nextPutAll: name
]
