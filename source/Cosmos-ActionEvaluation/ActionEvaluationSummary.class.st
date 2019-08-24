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
ActionEvaluationSummary class >> for: anActionEvaluation [

	^ self new initializeFor: anActionEvaluation
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
ActionEvaluationSummary >> initializeFor: anActionEvaluation [

	action := anActionEvaluation action.
	lastEvaluation := anActionEvaluation evaluationDateTime.
	evaluationCount := 1
]

{ #category : #accessing }
ActionEvaluationSummary >> lastEvaluation [

	^ lastEvaluation
]

{ #category : #updating }
ActionEvaluationSummary >> updateWith: anActionEvaluation [

	self assertActionMatch: anActionEvaluation.

	lastEvaluation := anActionEvaluation evaluationDateTime.
	evaluationCount := evaluationCount + 1
]
