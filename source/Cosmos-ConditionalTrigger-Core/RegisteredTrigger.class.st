Class {
	#name : #RegisteredTrigger,
	#superclass : #Object,
	#instVars : [
		'trigger',
		'triggeringPolicy'
	],
	#category : 'Cosmos-ConditionalTrigger-Core-Model'
}

{ #category : #'instance creation' }
RegisteredTrigger class >> holding: aTrigger accordingTo: aTriggeringPolicy [

	^ self new initializeHolding: aTrigger accordingTo: aTriggeringPolicy
]

{ #category : #registering }
RegisteredTrigger >> deregisterFrom: aTriggerManagementSystem [ 

	triggeringPolicy deregister: self from: aTriggerManagementSystem
]

{ #category : #triggering }
RegisteredTrigger >> ifSatisfiedOn: aContext withActionDo: aBlock [ 
	
	trigger ifSatisfiedOn: aContext withActionDo: aBlock
]

{ #category : #'initialize-release' }
RegisteredTrigger >> initializeHolding: aTrigger accordingTo: aTriggeringPolicy [ 

	trigger := aTrigger .
	triggeringPolicy := aTriggeringPolicy 
]

{ #category : #accessing }
RegisteredTrigger >> name [
	
	^ trigger name
]

{ #category : #registering }
RegisteredTrigger >> registerTo: aTriggerManagementSystem [ 

	triggeringPolicy register: self to: aTriggerManagementSystem
]
