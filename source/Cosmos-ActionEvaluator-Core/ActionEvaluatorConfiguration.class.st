Class {
	#name : #ActionEvaluatorConfiguration,
	#superclass : #Object,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-ActionEvaluator-Core'
}

{ #category : #'instance creation' }
ActionEvaluatorConfiguration class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #accessing }
ActionEvaluatorConfiguration >> currentDateTime [

	^ (cosmos >> #TimeSystemInterface) dateTime
]

{ #category : #accessing }
ActionEvaluatorConfiguration >> eventNotificationSystem [

	^ cosmos >> #EventNotificationSystemInterface
]

{ #category : #accessing }
ActionEvaluatorConfiguration >> httpClient [

	^ ZnClient new
]

{ #category : #initialization }
ActionEvaluatorConfiguration >> initializeWorkingWith: aCosmosSystem [

	cosmos :=  aCosmosSystem
]
