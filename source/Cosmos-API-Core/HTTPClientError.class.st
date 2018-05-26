Class {
	#name : #HTTPClientError,
	#superclass : #Error,
	#category : 'Cosmos-API-Core-Model'
}

{ #category : #signalling }
HTTPClientError class >> signal: aCode describedBy: aFailureExplanation [

	^ self new
		tag: aCode;
		signal: aFailureExplanation
]

{ #category : #signaling }
HTTPClientError class >> signalBadRequest: aFailureExplanation [

	^ self signal: 400 describedBy: aFailureExplanation
]

{ #category : #signalling }
HTTPClientError class >> signalConflict: aFailureExplanation [

	^self signal: 409 describedBy: aFailureExplanation
]

{ #category : #signalling }
HTTPClientError class >> signalNotFound [

	^self signal: 404 describedBy: 'Not found'
]

{ #category : #accessing }
HTTPClientError >> code [

	^self tag
]
