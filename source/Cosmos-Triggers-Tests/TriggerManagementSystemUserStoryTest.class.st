Class {
	#name : #TriggerManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Triggers-Tests-SystemModel'
}

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> eightPM [

	^ TimeOfDay hours: 20
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> ninePM [

	^ TimeOfDay hours: 21
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> octoberFirstOf2014AtNoon [

	^ (October first , 2014) atNoon
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> oneMinute [

	^ TimeUnits minute with: 1
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> setTriggeredToTrue [

	^ Action
		named: 'Set triggered to true'
		evaluating: (EvaluateBlockPolicy for: [ "triggered := true" ])
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> setTriggeredToTrueAfterDataPointRegistrationOn: aDataStream [

	^ ActionTrigger
		named: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: aDataStream)
		ifSatisfies: AlwaysTriggeringCondition new
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> setTriggeredToTrueEvery: aTimePeriod [

	^ self setTriggeredToTrueEvery: aTimePeriod ifSatisfies: AlwaysTriggeringCondition new
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> setTriggeredToTrueEvery: aTimePeriod ifSatisfies: aCondition [

	^ ActionTrigger
		named: ('Set triggered to true every <1p>' expandMacrosWith: aTimePeriod)
		triggering: self setTriggeredToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: aTimePeriod)
		ifSatisfies: aCondition
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> setTriggeredToTrueEveryFiveMinutes [

	^ self setTriggeredToTrueEvery: self fiveMinutes
]

{ #category : #running }
TriggerManagementSystemUserStoryTest >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self octoberFirstOf2014AtNoon));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: TriggerManagementSystem new
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> systemDateTime [
	
	^ self octoberFirstOf2014AtNoon 
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> temperatureStream [

	^ DataStream named: 'Temperature'
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> tenMinutes [

	^ TimeUnits minute with: 10
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testAccessing [ 
	
	self assert: self triggerManagementSystem name equals: 'Trigger Management'
	
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testDeregistrationFromPeriodicallyTriggered [

	| trigger |

	trigger := self setTriggeredToTrueEvery: self fiveMinutes.
	self triggerManagementSystem register: trigger.
	
	self
		assert: self triggerManagementSystem triggers
		hasTheSameElementsInTheSameOrderThat: {trigger}.
		
	self triggerManagementSystem deregister: trigger.
	
	self assert: self triggerManagementSystem triggers isEmpty 
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testDeregistrationFromTriggeredAfterDataPointRegistration [

	| trigger dataStream |

	dataStream := self temperatureStream.
	trigger := self setTriggeredToTrueAfterDataPointRegistrationOn: dataStream.
	self triggerManagementSystem register: trigger.
	self
		assert: self triggerManagementSystem triggers
		hasTheSameElementsInTheSameOrderThat: {trigger}.

	self triggerManagementSystem deregister: trigger.

	self assert: self triggerManagementSystem triggers isEmpty
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testMedataRegistrationOnTriggerRegistration [

	| dataStream metadata trigger |

	dataStream := self temperatureStream.
	trigger := self setTriggeredToTrueAfterDataPointRegistrationOn: dataStream .

	self assert: (self metadataSystem metadataFor: trigger) isEmpty.
	self triggerManagementSystem register: trigger.

	metadata := self metadataSystem metadataFor: trigger.
	self
		assert: metadata size equals: 2;
		assert: metadata
			equals:
			{(Metadata
				attaching: self currentIdentifier
				as: #identifier
				of: trigger).
			(Metadata
				attaching: self systemDateTime
				as: #registration_timestamp
				of: trigger)} asOrderedCollection 
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testRegistrationFailsIfTriggerWithSameNameAlreadyRegistered [

	self triggerManagementSystem register: self setTriggeredToTrueEveryFiveMinutes.

	self
		should: [ self triggerManagementSystem register: self setTriggeredToTrueEveryFiveMinutes ]
		raise: ConflictingObjectFound
		whoseDescriptionIncludes: 'Trigger with that name already exists in system'
		description: 'Expected: Trigger with that name already exists in system'
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testRegistrationToBePeriodicallyTriggered [

	| trigger |

	trigger := self setTriggeredToTrueEveryFiveMinutes.
	self triggerManagementSystem register: trigger.

	self
		withTheOnlyOneIn: self triggerManagementSystem triggers
		do: [ :foundTrigger | self assert: foundTrigger name equals: 'Set triggered to true every 5 minutes' ]
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testRegistrationToBeTriggeredOnDataPointRegistration [

	| trigger |

	trigger := self setTriggeredToTrueAfterDataPointRegistrationOn: self temperatureStream.
	self triggerManagementSystem register: trigger.

	self
		withTheOnlyOneIn: self triggerManagementSystem triggers
		do: [ :foundTrigger | 
			self
				assert: foundTrigger name
				equals: 'Set triggered to true after data point registration' ]
]
