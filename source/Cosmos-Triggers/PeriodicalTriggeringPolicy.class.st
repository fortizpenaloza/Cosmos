Class {
	#name : #PeriodicalTriggeringPolicy,
	#superclass : #TriggeringPolicy,
	#instVars : [
		'timePeriod'
	],
	#category : #'Cosmos-Triggers-Model'
}

{ #category : #'instance creation' }
PeriodicalTriggeringPolicy class >> every: aTimePeriod [ 

	^ self new initializeEvery: aTimePeriod
]

{ #category : #registering }
PeriodicalTriggeringPolicy >> deregister: aRegisteredTrigger from: aTriggerSystem [

	aTriggerSystem
		deregister: aRegisteredTrigger
		fromTriggeredPeriodicallyEvery: timePeriod
]

{ #category : #initialization }
PeriodicalTriggeringPolicy >> initializeEvery: aTimePeriod [

	timePeriod := aTimePeriod
]

{ #category : #registering }
PeriodicalTriggeringPolicy >> register: aTrigger to: aTriggerSystem [

	aTriggerSystem 
		register: aTrigger 
		toTriggerPeriodicallyEvery: timePeriod
]
