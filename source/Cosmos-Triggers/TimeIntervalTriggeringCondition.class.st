"
A TimeIntervalCondition is xxxxxxxxx.

"
Class {
	#name : #TimeIntervalTriggeringCondition,
	#superclass : #TriggeringCondition,
	#instVars : [
		'timeInterval'
	],
	#category : #'Cosmos-Triggers-Model'
}

{ #category : #'instance creation' }
TimeIntervalTriggeringCondition class >> checkingCurrentTimeIsBetween: aTimeInterval [

	^ self new initializeCheckingCurrentTimeIsBetween: aTimeInterval
]

{ #category : #'initialize-release' }
TimeIntervalTriggeringCondition >> initializeCheckingCurrentTimeIsBetween: aTimeInterval [ 

	timeInterval := aTimeInterval 
	
]

{ #category : #testing }
TimeIntervalTriggeringCondition >> isSatisfiedOn: aContext [

	^ timeInterval includes: aContext timeOfDay
]
