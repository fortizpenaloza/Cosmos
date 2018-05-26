Class {
	#name : #ActionTriggerTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Triggers-Tests-Model'
}

{ #category : #accessing }
ActionTriggerTest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #accessing }
ActionTriggerTest >> septemberSixthOf2014AtNoon [

	^ (September sixth , 2015) atNoon
]

{ #category : #tests }
ActionTriggerTest >> testInstanceCreationAndAccessing [

	| trigger triggered |

	triggered := false.

	trigger := ActionTrigger
		named: 'Set triggered to true'
		createdOn: self septemberSixthOf2014AtNoon
		triggering: [ triggered := true ]
		accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
		ifSatisfies: AlwaysTriggeringCondition new.

	self
		assert: trigger name equals: 'Set triggered to true';
		assert: trigger creationDateTime
			equals: self septemberSixthOf2014AtNoon;
		deny: triggered.

	trigger ifSatisfiedOn: nil withActionDo: [ :action | action value ].
	self assert: triggered
]
