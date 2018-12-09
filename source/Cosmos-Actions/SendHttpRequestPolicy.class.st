Class {
	#name : #SendHttpRequestPolicy,
	#superclass : #ActionEvaluationPolicy,
	#instVars : [
		'requestToSend'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #'instance creation' }
SendHttpRequestPolicy class >> sending: aRequest [

	^ self new initializeSending: aRequest
]

{ #category : #evaluating }
SendHttpRequestPolicy >> evaluateWith: aConfiguration [

	aConfiguration httpClient
		request: requestToSend;
		get
]

{ #category : #initialization }
SendHttpRequestPolicy >> initializeSending: aRequest [
	
	requestToSend := aRequest
]
