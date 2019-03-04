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

	anAction evaluateWith: configuration  
]

{ #category : #'events handling' }
ActionEvaluator >> evaluateOn: anEvaluateActionEvent [ 
	
	self evaluate: anEvaluateActionEvent action
]

{ #category : #initialization }
ActionEvaluator >> initializeConfiguredBy: aConfiguration [

	configuration := aConfiguration  
]
