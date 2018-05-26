Class {
	#name : #TriggeringCondition,
	#superclass : #Object,
	#category : 'Cosmos-ConditionalTrigger-Core-Model'
}

{ #category : #testing }
TriggeringCondition >> isSatisfiedOn: aContext [

	self subclassResponsibility 
]
