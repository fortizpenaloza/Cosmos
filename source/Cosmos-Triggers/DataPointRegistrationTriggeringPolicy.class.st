Class {
	#name : #DataPointRegistrationTriggeringPolicy,
	#superclass : #TriggeringPolicy,
	#instVars : [
		'dataStream'
	],
	#category : #'Cosmos-Triggers-Model'
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

{ #category : #initialization }
DataPointRegistrationTriggeringPolicy >> initializeOn: aDataStream [ 

	dataStream := aDataStream
]

{ #category : #registering }
DataPointRegistrationTriggeringPolicy >> register: aTrigger to: aTriggerSystem [

	aTriggerSystem
		register: aTrigger
		toTriggerAfterDataPointRegistrationOn: dataStream
]
