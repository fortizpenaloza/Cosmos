Class {
	#name : #DataPointRegistrationEvent,
	#superclass : #NotifiableEvent,
	#instVars : [
		'dataStream'
	],
	#category : 'Cosmos-Data-Core-SystemModel'
}

{ #category : #'instance creation' }
DataPointRegistrationEvent class >> on: aDataStream [

	^self new initializeOn: aDataStream
]

{ #category : #accessing }
DataPointRegistrationEvent >> dataStream [

	^ dataStream
]

{ #category : #'initialize-release' }
DataPointRegistrationEvent >> initializeOn: aDataStream [

	dataStream := aDataStream
]
