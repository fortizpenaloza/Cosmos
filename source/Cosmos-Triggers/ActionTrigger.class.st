Class {
	#name : #ActionTrigger,
	#superclass : #Object,
	#instVars : [
		'name',
		'creationDateTime',
		'action',
		'policy',
		'condition'
	],
	#category : #'Cosmos-Triggers-Model'
}

{ #category : #'instance creation' }
ActionTrigger class >> named: aName createdOn: aDateTime triggering: anAction accordingTo: aTriggeringPolicy ifSatisfies: aTriggeringCondition [

	^ self new
		initializeNamed: aName
		createdOn: aDateTime
		triggering: anAction
		accordingTo: aTriggeringPolicy
		ifSatisfies: aTriggeringCondition 
]

{ #category : #accessing }
ActionTrigger >> creationDateTime [

	^ creationDateTime
]

{ #category : #testing }
ActionTrigger >> ifSatisfiedOn: aContext withActionDo: aBlock [

	(condition isSatisfiedOn: aContext)
		ifTrue: [ aBlock value: action ]
]

{ #category : #'initialize-release' }
ActionTrigger >> initializeNamed: aName createdOn: aDateTime triggering: anAction accordingTo:  aTriggeringPolicy ifSatisfies: aTriggeringCondition [ 

	name := aName.
	creationDateTime := aDateTime.
	action := anAction .
	policy := aTriggeringPolicy.
	condition := aTriggeringCondition 

]

{ #category : #accessing }
ActionTrigger >> name [
	
	^ name 
]

{ #category : #accessing }
ActionTrigger >> triggeringPolicy [

	^ policy
]
