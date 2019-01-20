Class {
	#name : #WellKnownObjectDecoder,
	#superclass : #Object,
	#instVars : [
		'queriedSystem',
		'messageToSend'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
WellKnownObjectDecoder class >> querying: anInterface on: aCosmosSystem sending: aMessage [

	^ self new initializeQuerying: anInterface on: aCosmosSystem sending: aMessage
]

{ #category : #decoding }
WellKnownObjectDecoder >> decode: aString [

	^ [ queriedSystem perform: messageToSend with: aString ]
		on: ObjectNotFound
		do: [ :signal | InstanceCreationFailed signal: signal messageText ]
]

{ #category : #initialization }
WellKnownObjectDecoder >> initializeQuerying: anInterface on: aCosmosSystem sending: aMessage [

	queriedSystem := aCosmosSystem >> anInterface .
	messageToSend := aMessage
]
