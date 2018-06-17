Class {
	#name : #TriggeringCondition,
	#superclass : #Object,
	#category : #'Cosmos-Triggers-Model'
}

{ #category : #testing }
TriggeringCondition >> isSatisfiedOn: aContext [

	self subclassResponsibility 
]
