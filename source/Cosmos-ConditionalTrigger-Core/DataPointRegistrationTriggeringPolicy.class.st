Class {
	#name : #DataPointRegistrationTriggeringPolicy,
	#superclass : #TriggeringPolicy,
	#instVars : [
		'dataStream'
	],
	#category : 'Cosmos-ConditionalTrigger-Core-Model'
}

{ #category : #'instance creation' }
DataPointRegistrationTriggeringPolicy class >> on: aDataStream [ 
	
	^ self new initializeOn: aDataStream
]

{ #category : #registering }
DataPointRegistrationTriggeringPolicy >> deregister: aRegisteredTrigger from: aTriggerSystem [

	aTriggerSystem
		deregister: aRegisteredTrigger
		toStopTriggeringAfterDataPointRegistrationOn: dataStream
]

{ #category : #'initialize-release' }
DataPointRegistrationTriggeringPolicy >> initializeOn: aDataStream [ 

	dataStream := aDataStream
]

{ #category : #registering }
DataPointRegistrationTriggeringPolicy >> register: aTrigger to: aTriggerSystem [

	aTriggerSystem
		register: aTrigger
		toTriggerAfterDataPointRegistrationOn: dataStream
]
