Class {
	#name : #ActionTriggerTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Triggers-Tests-Model'
}

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
		triggering: [ triggered := true ]
		accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
		ifSatisfies: AlwaysTriggeringCondition new.

	self
		assert: trigger name
			equals: 'Set triggered to true periodically every 5 minutes';
		deny: triggered.

	trigger ifSatisfiedOn: nil withActionDo: [ :action | action value ].
	self assert: triggered
]

{ #category : #tests }
ActionTriggerTest >> testPrintOn [

	| trigger |

	trigger := ActionTrigger
		named: 'Set triggered to true periodically every 5 minutes'
		triggering: [  ]
		accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
		ifSatisfies: AlwaysTriggeringCondition new.

	self
		assert: trigger printString
		equals: 'Set triggered to true periodically every 5 minutes'
]
