Class {
	#name : #ActionEvaluationPolicy,
	#superclass : #Object,
	#category : #'Cosmos-Actions'
}

{ #category : #evaluating }
ActionEvaluationPolicy >> evaluateWithin: anEvaluationContext [

	self subclassResponsibility 
]
