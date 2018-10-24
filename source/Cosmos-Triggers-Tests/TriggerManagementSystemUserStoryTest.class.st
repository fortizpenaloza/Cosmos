Class {
	#name : #TriggerManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'triggered'
	],
	#category : 'Cosmos-Triggers-Tests-SystemModel'
}

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> eightPM [

	^ TimeOfDay hours: 20
]

{ #category : #'action evaluation' }
TriggerManagementSystemUserStoryTest >> evaluateActionOn: anEvaluateActionEvent [

	ActionEvaluator new evaluate: anEvaluateActionEvent action
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
TriggerManagementSystemUserStoryTest >> oneMinute [

	^ TimeUnits minute with: 1
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> setTriggeredToTrue [

	^ Action
		named: 'Set triggered to true'
		evaluating: (EvaluateBlockPolicy for: [ triggered := true ])
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> setTriggeredToTrueAfterDataPointRegistrationOn: aDataStream [

	^ ActionTrigger
		named: 'Set triggered to true after data point registration'
		createdOn: self systemDateTime
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
		createdOn: self systemDateTime
		triggering: self setTriggeredToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: aTimePeriod)
		ifSatisfies: aCondition
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> setTriggeredToTrueEveryFiveMinutes [

	^ self setTriggeredToTrueEvery: self fiveMinutes
]

{ #category : #running }
TriggerManagementSystemUserStoryTest >> setUp [
	
	super setUp. 
	triggered := false.
]

{ #category : #running }
TriggerManagementSystemUserStoryTest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem;
		requireActionManagementSystem;
		requireTriggerManagementSystem

]

{ #category : #'tests - support' }
TriggerManagementSystemUserStoryTest >> suscribeToEvaluateActionEvent [

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:
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
TriggerManagementSystemUserStoryTest >> testDeregistrationFromPeriodicallyTriggered [

	| trigger |

	trigger := self setTriggeredToTrueEvery: self fiveMinutes.
	self triggerManagementSystem register: trigger.
	
	self
		assert: self triggerManagementSystem triggers
		hasTheSameElementsInTheSameOrderThat: {trigger}.
		
	self triggerManagementSystem deregisterNamed: 'Set triggered to true every 5 minutes'.
	
	self assert: self triggerManagementSystem triggers isEmpty 
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testDeregistrationFromTriggeredAfterDataPointRegistration [

	| dataStream trigger |

	dataStream := self temperatureStream.

	trigger := self setTriggeredToTrueAfterDataPointRegistrationOn: dataStream .
	self triggerManagementSystem register: trigger.
	self
		assert: self triggerManagementSystem triggers
		hasTheSameElementsInTheSameOrderThat: {trigger}.

	self triggerManagementSystem
		deregisterNamed: 'Set triggered to true after data point registration'.

	self assert: self triggerManagementSystem triggers isEmpty
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

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testTriggerOnDataPointRegistrationWhenSatisfiesDataStreamCurrentValueCondition [

	| dataStream trigger |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.
	self suscribeToEvaluateActionEvent.

	trigger := ActionTrigger
		named: 'Set triggered to true after data point registration'
		createdOn: self systemDateTime
		triggering: self setTriggeredToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: dataStream)
		ifSatisfies: (DataStreamCurrentValueTriggeringCondition of: dataStream isLessThan: 11).
	self triggerManagementSystem register: trigger.

	self deny: triggered.
	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 12)
		toStreamNamed: dataStream name.
	self deny: triggered.
	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 10)
		toStreamNamed: dataStream name.
	self assert: triggered
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testTriggerPeriodicallyEveryTenMinutes [

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	self triggerManagementSystem register: self setTriggeredToTrueEveryFiveMinutes.
	self deny: triggered.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self oneMinute).

	self deny: triggered.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self fiveMinutes).
		
	self assert: triggered
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testTriggerPeriodicallyEveryTenMinutesIfDataStreamHasNotBeenUpdated [

	| dataStream condition |

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		checkingIf: dataStream
		hasNotBeenUpdatedForMoreThan: self fiveMinutes.

 	self triggerManagementSystem register: (self setTriggeredToTrueEvery: self tenMinutes ifSatisfies: condition).
	self deny: triggered.

	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 12)
		toStreamNamed: dataStream name.
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self fiveMinutes).
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self tenMinutes).
	self assert: triggered
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testTriggerPeriodicallyEveryTenMinutesWhenSatisfiesDataStreamCurrentValueDuringATimeInterval [

	| dataStream condition |

	self suscribeToEvaluateActionEvent.
	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	condition := AndCompositeTriggeringCondition
		with:
			(DataStreamCurrentValueTriggeringCondition
				of: dataStream
				isLessThan: 11)
		with:
			(TimeIntervalTriggeringCondition
				checkingCurrentTimeIsBetween: (self eightPM to: self ninePM)).

	self triggerManagementSystem
		register: (self setTriggeredToTrueEvery: self tenMinutes ifSatisfies: condition).

	self deny: triggered.

	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 10)
		toStreamNamed: dataStream name.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.

	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 12)
		toStreamNamed: dataStream name.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.

	timeSource setTimeTo: self eightPM.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.

	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 10)
		toStreamNamed: dataStream name.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
	self assert: triggered
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testTriggeringOnDataPointRegistration [

	| dataStream |

	self suscribeToEvaluateActionEvent.
	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	self triggerManagementSystem
		register: (self setTriggeredToTrueAfterDataPointRegistrationOn: dataStream).

	self deny: triggered.
	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 12)
		toStreamNamed: dataStream name.
	self assert: triggered
]
