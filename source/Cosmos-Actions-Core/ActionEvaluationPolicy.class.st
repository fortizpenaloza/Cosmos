Class {
	#name : #ActionEvaluationPolicy,
	#superclass : #Object,
	#category : 'Cosmos-Actions-Core-Model'
}

{ #category : #evaluating }
ActionEvaluationPolicy >> evaluateWith: anActionEvaluatorConfiguration [

	self subclassResponsibility 
]
