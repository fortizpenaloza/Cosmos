Class {
	#name : #HTTPRequestEvaluationPolicy,
	#superclass : #ActionEvaluationPolicy,
	#instVars : [
		'requestToSend'
	],
	#category : 'Cosmos-Actions-Core-Model'
}

{ #category : #'instance creation' }
HTTPRequestEvaluationPolicy class >> for: aRequest [

	^ self new initializeFor: aRequest
]

{ #category : #evaluating }
HTTPRequestEvaluationPolicy >> evaluateWith: aConfiguration [

	aConfiguration httpClient
		request: requestToSend;
		get
]

{ #category : #'initialize-release' }
HTTPRequestEvaluationPolicy >> initializeFor: aRequest [
	
	requestToSend := aRequest
]
