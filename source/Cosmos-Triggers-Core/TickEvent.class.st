Class {
	#name : #TickEvent,
	#superclass : #NotifiableEvent,
	#instVars : [
		'timePeriod'
	],
	#category : 'Cosmos-Triggers-Core-SystemModel'
}

{ #category : #'instance-creation' }
TickEvent class >> of: aTimePeriod [
	
	^ self new initializeOf: aTimePeriod 
]

{ #category : #'initialize-release' }
TickEvent >> initializeOf: aTimePeriod [
	
	timePeriod := aTimePeriod 
]

{ #category : #accessing }
TickEvent >> timePeriod [

	^ timePeriod
]
