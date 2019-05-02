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
		deny: triggered;
		assert: (trigger triggeringPolicy isKindOf: PeriodicalTriggeringPolicy).
]

{ #category : #tests }
ActionTriggerTest >> testInstanceCreationFailsWithEmptyName [

	self
		should: [ ActionTrigger
				named: ''
				triggering: [ "do nothing" ]
				accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
				ifSatisfies: AlwaysTriggeringCondition new ]
		raise: InstanceCreationFailed
		withMessageText: 'Action trigger name must not be empty'
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

{ #category : #tests }
ActionTriggerTest >> testTriggering [

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

	trigger do: [ :action | action value ] ifSatisfiedWithin: self.
	self assert: triggered
]
