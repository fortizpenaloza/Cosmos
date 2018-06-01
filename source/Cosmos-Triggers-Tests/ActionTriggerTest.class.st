Class {
	#name : #ActionTriggerTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Triggers-Tests-Model'
}

{ #category : #accessing }
ActionTriggerTest >> decemberTenthOf2016AtNoon [

	^ (December tenth , 2016) atNoon
]

{ #category : #accessing }
ActionTriggerTest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #tests }
ActionTriggerTest >> testInstanceCreationAndAccessing [

	| trigger triggered |

	triggered := false.

	trigger := ActionTrigger
		named: 'Set triggered to true periodically every 5 minutes'
		createdOn: self decemberTenthOf2016AtNoon
		triggering: [ triggered := true ]
		accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
		ifSatisfies: AlwaysTriggeringCondition new.

	self
		assert: trigger name equals: 'Set triggered to true periodically every 5 minutes';
		assert: trigger creationDateTime
			equals: self decemberTenthOf2016AtNoon;
		deny: triggered.

	trigger ifSatisfiedOn: nil withActionDo: [ :action | action value ].
	self assert: triggered
]
