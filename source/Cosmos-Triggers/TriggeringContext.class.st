Class {
	#name : #TriggeringContext,
	#superclass : #Object,
	#instVars : [
		'dateTime'
	],
	#category : #'Cosmos-Triggers-SystemModel'
}

{ #category : #'instance creation' }
TriggeringContext class >> providing: aDateTime [ 

	^ self new initializeProviding: aDateTime
]

{ #category : #accessing }
TriggeringContext >> dateTime [

	^ dateTime
]

{ #category : #initialization }
TriggeringContext >> initializeProviding: aDateTime [ 

	dateTime := aDateTime 
]

{ #category : #accessing }
TriggeringContext >> timeOfDay [

	^ dateTime timeOfDay 
]
