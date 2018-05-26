Class {
	#name : #TriggeringCondition,
	#superclass : #Object,
	#category : 'Cosmos-Triggers-Core-Model'
}

{ #category : #testing }
TriggeringCondition >> isSatisfiedOn: aContext [

	self subclassResponsibility 
]
