Class {
	#name : #DataStreamHasNotBeenUpdatedTriggeringCondition,
	#superclass : #TriggeringCondition,
	#instVars : [
		'dataStream',
		'timePeriod'
	],
	#category : 'Cosmos-Triggers-Core-Model'
}

{ #category : #'instance creation' }
DataStreamHasNotBeenUpdatedTriggeringCondition class >> checkingIf: aDataStream hasNotBeenUpdatedForMoreThan: aTimePeriod [

	^ self new
		initializeCheckingIf: aDataStream
		hasNotBeenUpdatedForMoreThan: aTimePeriod
]

{ #category : #'initialize-release' }
DataStreamHasNotBeenUpdatedTriggeringCondition >> initializeCheckingIf: aDatastream hasNotBeenUpdatedForMoreThan: aTimePeriod [

	dataStream := aDatastream.
	timePeriod := aTimePeriod
]

{ #category : #testing }
DataStreamHasNotBeenUpdatedTriggeringCondition >> isSatisfiedOn: aContext [

	^ (dataStream lastUpdate distanceTo: aContext dateTime) > timePeriod 
]
