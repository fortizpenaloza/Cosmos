Class {
	#name : #ActionEvaluationPolicy,
	#superclass : #Object,
	#category : #'Cosmos-Actions'
}

{ #category : #evaluating }
ActionEvaluationPolicy >> evaluateWith: anActionEvaluatorConfiguration [

	self subclassResponsibility 
]
