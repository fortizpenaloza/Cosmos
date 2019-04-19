Class {
	#name : #ActionEvaluationSummary,
	#superclass : #Object,
	#instVars : [
		'action',
		'lastEvaluation',
		'evaluationCount'
	],
	#category : #'Cosmos-ActionEvaluation'
}

{ #category : #'instance creation' }
ActionEvaluationSummary class >> of: anActionEvaluation [

	^ self
		of: anActionEvaluation action
		lastEvaluatedOn: anActionEvaluation evaluationDateTime
]

{ #category : #'instance creation' }
ActionEvaluationSummary class >> of: anAction lastEvaluatedOn: aDateTime [

	^ self new initializeOf: anAction lastEvaluatedOn: aDateTime
]

{ #category : #accessing }
ActionEvaluationSummary >> action [

	^ action
]

{ #category : #'private - updating' }
ActionEvaluationSummary >> assertActionMatch: anActionEvaluation [

	action = anActionEvaluation action
		ifFalse: [ ConflictingObjectFound
				signal: 'Action summary does not belong to this action' ]
]

{ #category : #accessing }
ActionEvaluationSummary >> evaluationCount [

	^ evaluationCount
]

{ #category : #initialization }
ActionEvaluationSummary >> initializeOf: anAction lastEvaluatedOn: aDateTime [

	action :=  anAction.
	lastEvaluation :=  aDateTime.
	evaluationCount :=  1
	

	
]

{ #category : #accessing }
ActionEvaluationSummary >> lastEvaluation [

	^ lastEvaluation
]

{ #category : #updating }
ActionEvaluationSummary >> synchronizeWith: anActionEvaluation [

	self assertActionMatch: anActionEvaluation.

	lastEvaluation := anActionEvaluation evaluationDateTime.
	evaluationCount := evaluationCount + 1
]
