Class {
	#name : #EvaluateActionEvent,
	#superclass : #NotifiableEvent,
	#instVars : [
		'action'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #'instance creation' }
EvaluateActionEvent class >> of: anAction [
		
	^ self new initializeOf: anAction
]

{ #category : #accessing }
EvaluateActionEvent >> action [
	self flag: 'matar esto'.
	^ action
]

{ #category : #initialization }
EvaluateActionEvent >> initializeOf: anAction [

	action := anAction
]
