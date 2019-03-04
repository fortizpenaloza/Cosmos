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

{ #category : #evaluating }
ActionEvaluator >> evaluate: anAction [ 

	anAction evaluateWithin: configuration  
]

{ #category : #'events handling' }
ActionEvaluator >> handleEvaluateActionOn: anEvent [ 
	
	self evaluate: anEvent action
]

{ #category : #initialization }
ActionEvaluator >> initializeConfiguredBy: aConfiguration [

	configuration := aConfiguration  
]
