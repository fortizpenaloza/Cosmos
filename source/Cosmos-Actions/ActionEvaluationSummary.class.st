Class {
	#name : #ActionEvaluationSummary,
	#superclass : #Object,
	#instVars : [
		'action',
		'lastEvaluation',
		'evaluationCount'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #'instance creation' }
ActionEvaluationSummary class >> of: anAction lastEvaluatedOn: aDateTime totaling: anEvaluationCount [

	^ self new
		initializeOf: anAction
		lastEvaluatedOn: aDateTime
		totaling: anEvaluationCount
]

{ #category : #accessing }
ActionEvaluationSummary >> action [

	^ action
]

{ #category : #accessing }
ActionEvaluationSummary >> evaluationCount [

	^ evaluationCount
]

{ #category : #initialization }
ActionEvaluationSummary >> initializeOf: anAction lastEvaluatedOn: aDateTime totaling: anEvaluationCount [

	action :=  anAction.
	lastEvaluation :=  aDateTime.
	evaluationCount :=  anEvaluationCount
	

	
]

{ #category : #accessing }
ActionEvaluationSummary >> lastEvaluation [

	^ lastEvaluation
]

{ #category : #updating }
ActionEvaluationSummary >> registerEvaluationOn: aDateTime [

	lastEvaluation := aDateTime.
	evaluationCount := evaluationCount + 1
]
