"
I am a trigger condition.

I collaborate with a ConditionalTrigger as a null condition. 
"
Class {
	#name : #AlwaysTriggeringCondition,
	#superclass : #TriggeringCondition,
	#category : 'Cosmos-Triggers-Core-Model'
}

{ #category : #testing }
AlwaysTriggeringCondition >> isSatisfiedOn: aContext [

	^ true
]
