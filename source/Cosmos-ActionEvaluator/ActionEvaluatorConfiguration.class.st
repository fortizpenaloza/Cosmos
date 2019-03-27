Class {
	#name : #ActionEvaluatorConfiguration,
	#superclass : #Object,
	#instVars : [
		'timeSource'
	],
	#category : #'Cosmos-ActionEvaluator'
}

{ #category : #'instance creation' }
ActionEvaluatorConfiguration class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #accessing }
ActionEvaluatorConfiguration >> dateTime [

	^ timeSource dateTime
]

{ #category : #accessing }
ActionEvaluatorConfiguration >> httpClient [

	^ ZnClient new
]

{ #category : #initialization }
ActionEvaluatorConfiguration >> initializeWorkingWith: aTimeSource [

	timeSource :=  aTimeSource
]
