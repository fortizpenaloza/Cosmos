"
I'm an exception expecting to be raised when someone tries to query current value or last updated timestamp of an empty data stream.
"
Class {
	#name : #DataStreamIsEmpty,
	#superclass : #Exception,
	#category : #'Cosmos-Data-Model'
}

{ #category : #signaling }
DataStreamIsEmpty class >> signalAll: failureExplanations [

	^ self new
		tag: failureExplanations;
		signal: ('. ' join: failureExplanations)
]

{ #category : #accessing }
DataStreamIsEmpty >> defaultAction [

	UnhandledError signalForException: self
]
