Class {
	#name : #EvaluateActionEvent,
	#superclass : #NotifiableEvent,
	#instVars : [
		'action'
	],
	#category : 'Cosmos-Actions-Core-Model'
}

{ #category : #'instance creation' }
EvaluateActionEvent class >> of: anAction [
		
	^ self new initializeOf: anAction
]

{ #category : #accessing }
EvaluateActionEvent >> action [

	^ action
]

{ #category : #'initialize-release' }
EvaluateActionEvent >> initializeOf: anAction [

	action := anAction
]
