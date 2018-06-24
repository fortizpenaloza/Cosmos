Class {
	#name : #ActionEvaluationPolicy,
	#superclass : #Object,
	#category : #'Cosmos-Actions-Model'
}

{ #category : #evaluating }
ActionEvaluationPolicy >> evaluateWith: anActionEvaluatorConfiguration [

	self subclassResponsibility 
]
