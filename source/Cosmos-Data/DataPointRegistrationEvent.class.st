"
I'm a data point registration event, a notifiable event. I'm being used to notify the registration of a data point on a data stream.
"
Class {
	#name : #DataPointRegistrationEvent,
	#superclass : #NotifiableEvent,
	#instVars : [
		'dataStream'
	],
	#category : #'Cosmos-Data'
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
