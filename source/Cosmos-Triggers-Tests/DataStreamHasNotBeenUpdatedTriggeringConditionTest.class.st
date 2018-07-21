Class {
	#name : #DataStreamHasNotBeenUpdatedTriggeringConditionTest,
	#superclass : #TestCase,
	#instVars : [
		'dateTime',
		'lastUpdate'
	],
	#category : 'Cosmos-Triggers-Tests-Model'
}

{ #category : #accessing }
DataStreamHasNotBeenUpdatedTriggeringConditionTest >> dateTime [

	^ dateTime
]

{ #category : #accessing }
DataStreamHasNotBeenUpdatedTriggeringConditionTest >> decemberTenthOf2016AtNoon [

	^ (December tenth , 2016) atNoon
]

{ #category : #accessing }
DataStreamHasNotBeenUpdatedTriggeringConditionTest >> lastUpdate [

	^ lastUpdate
]

{ #category : #tests }
DataStreamHasNotBeenUpdatedTriggeringConditionTest >> testIsSafisfiedWhenDataStreamHasntBeenInitialized [

	| condition |

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		checkingIf:
			(DataStream
				named: 'Temperature'
				createdOn: self decemberTenthOf2016AtNoon)
		hasNotBeenUpdatedForMoreThan: (TimeUnits minute with: 10).

	self
		should: [ (condition isSatisfiedOn: self) ]
		raise: DataStreamIsEmpty
		withDescription: 'Last update date and time has not been initialized'
]

{ #category : #tests }
DataStreamHasNotBeenUpdatedTriggeringConditionTest >> testIsSafistied [

	| condition |

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		checkingIf: self
		hasNotBeenUpdatedForMoreThan: (TimeUnits minute with: 10).

	dateTime := September tenth , 2014 atTimeOfDay: (TimeOfDay hours: 19).
	lastUpdate := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19).
	self deny: (condition isSatisfiedOn: self).

	dateTime := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19 minutes: 20).
	lastUpdate := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19).
	self assert: (condition isSatisfiedOn: self).

	dateTime := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19 minutes: 9).
	lastUpdate := September tenth , 2014
		atTimeOfDay: (TimeOfDay hours: 19).
	self deny: (condition isSatisfiedOn: self)
]
