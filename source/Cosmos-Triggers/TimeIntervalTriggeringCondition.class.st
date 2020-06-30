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

	| timeOfDay |

	timeOfDay := aContext timeOfDay.
	^ timeInterval
		includes:
			( TimeOfDay
				hours: timeOfDay hours amount
				minutes: timeOfDay minutes amount
				seconds: timeOfDay seconds amount )
]
