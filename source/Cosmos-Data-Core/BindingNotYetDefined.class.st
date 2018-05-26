Class {
	#name : #BindingNotYetDefined,
	#superclass : #Exception,
	#category : 'Cosmos-Data-Core-Model'
}

{ #category : #signaling }
BindingNotYetDefined class >> signalAll: failureExplanations [

	^ self new
		tag: failureExplanations;
		signal: ('. ' join: failureExplanations)
]

{ #category : #accessing }
BindingNotYetDefined >> defaultAction [

	UnhandledError signalForException: self
]
