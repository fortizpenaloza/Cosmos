Class {
	#name : #Trigger,
	#superclass : #Object,
	#instVars : [
		'action',
		'condition',
		'name',
		'creationDateTime'
	],
	#category : 'Cosmos-ConditionalTrigger-Core-Model'
}

{ #category : #'instance creation' }
Trigger class >> named: aName createdOn: aDateTime triggering: anAction whenMeets: aTriggeringCondition [

	^ self new
		initializeNamed: aName
		createdOn: aDateTime
		triggering: anAction
		whenMeets: aTriggeringCondition
]

{ #category : #accessing }
Trigger >> creationDateTime [

	^ creationDateTime
]

{ #category : #triggering }
Trigger >> ifSatisfiedOn: aContext withActionDo: aBlock [

	(condition isSatisfiedOn: aContext)
		ifTrue: [ aBlock value: action ]
]

{ #category : #'initialize-release' }
Trigger >> initializeNamed: aName createdOn: aDateTime triggering: anAction whenMeets: aTriggeringCondition [ 

	name := aName.
	creationDateTime := aDateTime.
	action := anAction .
	condition := aTriggeringCondition 

]

{ #category : #accessing }
Trigger >> name [
	
	^ name 
]
