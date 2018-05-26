Class {
	#name : #AndCompositeTriggeringCondition,
	#superclass : #TriggeringCondition,
	#instVars : [
		'triggerConditions'
	],
	#category : 'Cosmos-ConditionalTrigger-Core-Model'
}

{ #category : #'instance creation' }
AndCompositeTriggeringCondition class >> with: aTrigger with: anotherTrigger [

	^ self
		withAll:
			{aTrigger.
			anotherTrigger}
]

{ #category : #'instance creation' }
AndCompositeTriggeringCondition class >> withAll: aTriggerCollection [

	^ self new initializeWith: aTriggerCollection 
]

{ #category : #'initialize-release' }
AndCompositeTriggeringCondition >> initializeWith: aTriggerConditionCollection [

	triggerConditions := aTriggerConditionCollection
]

{ #category : #testing }
AndCompositeTriggeringCondition >> isSatisfiedOn: aContext [

	^ triggerConditions
		allSatisfy: [ :triggerCondition | triggerCondition isSatisfiedOn: aContext ]
]
