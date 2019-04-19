Class {
	#name : #ActionTrigger,
	#superclass : #Object,
	#instVars : [
		'name',
		'action',
		'policy',
		'condition'
	],
	#category : #'Cosmos-Triggers-Model'
}

{ #category : #'instance creation' }
ActionTrigger class >> named: aName triggering: anAction accordingTo: aTriggeringPolicy ifSatisfies: aTriggeringCondition [

	^ self new
		initializeNamed: aName
		triggering: anAction
		accordingTo: aTriggeringPolicy
		ifSatisfies: aTriggeringCondition
]

{ #category : #testing }
ActionTrigger >> do: aBlock ifSatisfiedWithin: aContext [

	(condition isSatisfiedOn: aContext)
		ifTrue: [ aBlock value: action ]
]

{ #category : #initialization }
ActionTrigger >> initializeNamed: aName triggering: anAction accordingTo: aTriggeringPolicy ifSatisfies: aTriggeringCondition [

	name := aName.
	action := anAction.
	policy := aTriggeringPolicy.
	condition := aTriggeringCondition
]

{ #category : #accessing }
ActionTrigger >> name [
	
	^ name 
]

{ #category : #printing }
ActionTrigger >> printOn: aStream [

	aStream nextPutAll: name
]

{ #category : #accessing }
ActionTrigger >> triggeringPolicy [

	^ policy
]
