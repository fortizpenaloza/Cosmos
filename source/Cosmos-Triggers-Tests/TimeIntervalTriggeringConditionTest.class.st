"
A TimeIntervalConditionTest is a test class for testing the behavior of TimeIntervalCondition
"
Class {
	#name : #TimeIntervalTriggeringConditionTest,
	#superclass : #TestCase,
	#instVars : [
		'timeOfDay'
	],
	#category : #'Cosmos-Triggers-Tests-Model'
}

{ #category : #accessing }
TimeIntervalTriggeringConditionTest >> eightPM [

	^ TimeOfDay hours: 20
]

{ #category : #accessing }
TimeIntervalTriggeringConditionTest >> ninePM [

		^ TimeOfDay hours: 21
]

{ #category : #accessing }
TimeIntervalTriggeringConditionTest >> sevenPM [

	^ TimeOfDay hours: 19
]

{ #category : #accessing }
TimeIntervalTriggeringConditionTest >> tenPM [

	^ TimeOfDay hours: 22
]

{ #category : #tests }
TimeIntervalTriggeringConditionTest >> testIsSafistied [

	| condition |

	condition := TimeIntervalTriggeringCondition
		checkingCurrentTimeIsBetween: ( self eightPM to: self tenPM ).

	timeOfDay := self eightPM.
	self assert: ( condition isSatisfiedOn: self ).

	timeOfDay := self sevenPM.
	self deny: ( condition isSatisfiedOn: self ).

	timeOfDay := TimeOfDay hours: 20 minutes: 01.
	self assert: ( condition isSatisfiedOn: self ).

	timeOfDay := self tenPM.
	self assert: ( condition isSatisfiedOn: self ).

	timeOfDay := TimeOfDay hours: 22 minutes: 00 seconds: 01.
	self deny: ( condition isSatisfiedOn: self )
]

{ #category : #tests }
TimeIntervalTriggeringConditionTest >> testIsSafistiedWhenSpansBeforeMidnigth [ 

	| condition |

	condition := TimeIntervalTriggeringCondition
		checkingCurrentTimeIsBetween: (self tenPM to: self eightPM).

	timeOfDay := self eightPM.
	self assert: (condition isSatisfiedOn: self).

	timeOfDay := self ninePM.
	self deny: (condition isSatisfiedOn: self).

	timeOfDay := TimeOfDay hours: 20 minutes: 01.
	self deny: (condition isSatisfiedOn: self).

	timeOfDay := self tenPM.
	self assert: (condition isSatisfiedOn: self).

	timeOfDay := TimeOfDay hours: 22 minutes: 00 seconds: 01.
	self assert: (condition isSatisfiedOn: self)
]

{ #category : #accessing }
TimeIntervalTriggeringConditionTest >> timeOfDay [

	^ timeOfDay
]
