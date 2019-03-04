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
ActionEvaluationSummary class >> for: anAction lastUpdatedOn: aDateTime totaling: aCount [ 
		
	^ self new initializeFor: anAction lastUpdatedOn: aDateTime totaling: aCount 
]

{ #category : #initialization }
ActionEvaluationSummary >> initializeFor: anAction lastUpdatedOn: aDateTime totaling: aCount [

	action :=  anAction.
	lastEvaluation :=  aDateTime.
	evaluationCount :=  aCount
	

	
]
