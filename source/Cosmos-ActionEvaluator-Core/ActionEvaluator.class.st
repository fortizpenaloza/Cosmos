Class {
	#name : #ActionEvaluator,
	#superclass : #Object,
	#instVars : [
		'configuration'
	],
	#category : 'Cosmos-ActionEvaluator-Core'
}

{ #category : #'instance creation' }
ActionEvaluator class >> configuredBy: aConfiguration [

	^ self new initializeConfiguredBy: aConfiguration
]

{ #category : #accessing }
ActionEvaluator >> currentDateTime [

	^ configuration currentDateTime
]

{ #category : #evaluating }
ActionEvaluator >> evaluate: anAction [

	anAction evaluateWithin: configuration.
	self notifyEvaluationOf: anAction
]

{ #category : #'private - systems' }
ActionEvaluator >> eventNotificationSystem [
	
	^ configuration eventNotificationSystem  
]

{ #category : #'events handling' }
ActionEvaluator >> handleEvaluateActionOn: anEvent [ 
	
	self evaluate: anEvent action
]

{ #category : #initialization }
ActionEvaluator >> initializeConfiguredBy: aConfiguration [

	configuration := aConfiguration  
]

{ #category : #evaluating }
ActionEvaluator >> notifyEvaluationOf: anAction [

	self eventNotificationSystem
		notifySubscribersTo: (ActionEvaluatedEvent of: anAction on: self currentDateTime)
]
