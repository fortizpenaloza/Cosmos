Class {
	#name : #WellKnownObjectDecoder,
	#superclass : #Decoder,
	#instVars : [
		'messageToSend',
		'systemToQuery'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
WellKnownObjectDecoder class >> querying: aSystem sending: aMessage [

	^ self new initializeQuerying: aSystem sending: aMessage
]

{ #category : #decoding }
WellKnownObjectDecoder >> decode: aString [

	^ [ systemToQuery perform: messageToSend with: aString ]
		on: ObjectNotFound
		do: [ :signal | InstanceCreationFailed signal: signal messageText ]
]

{ #category : #initialization }
WellKnownObjectDecoder >> initializeQuerying: aSystem sending: aMessage [

	systemToQuery := aSystem.
	messageToSend := aMessage
]
