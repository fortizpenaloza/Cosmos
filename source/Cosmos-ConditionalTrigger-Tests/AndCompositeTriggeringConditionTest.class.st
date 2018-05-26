"
An AndCompositeTriggerConditionTest is a test class for testing the behavior of AndCompositeTriggerCondition
"
Class {
	#name : #AndCompositeTriggeringConditionTest,
	#superclass : #TestCase,
	#instVars : [
		'timeOfDay',
		'currentValue'
	],
	#category : 'Cosmos-ConditionalTrigger-Tests-Model'
}

{ #category : #accessing }
AndCompositeTriggeringConditionTest >> currentValue [

	^ currentValue
]

{ #category : #accessing }
AndCompositeTriggeringConditionTest >> eightPM [
	
	^ TimeOfDay hours: 20
]

{ #category : #accessing }
AndCompositeTriggeringConditionTest >> elevenPM [

	^ TimeOfDay hours: 23
]

{ #category : #accessing }
AndCompositeTriggeringConditionTest >> tenPM [

	^ TimeOfDay hours: 22
]

{ #category : #tests }
AndCompositeTriggeringConditionTest >> testIsSatisfied [

	| condition |

	condition := AndCompositeTriggeringCondition
		withAll:
			(OrderedCollection
				with:
					(TimeIntervalTriggeringCondition
						checkingCurrentTimeIsBetween: (self eightPM to: self tenPM))
				with: (DataStreamCurrentValueTriggeringCondition of: self isLessThan: 10)).

	currentValue := 9.
	timeOfDay := self eightPM.
	self assert: (condition isSatisfiedOn: self).

	currentValue := 10.
	timeOfDay := self eightPM.
	self deny: (condition isSatisfiedOn: self).

	currentValue := 9.
	timeOfDay := self elevenPM.
	self deny: (condition isSatisfiedOn: self)
]

{ #category : #accessing }
AndCompositeTriggeringConditionTest >> timeOfDay [

	^ timeOfDay
]
