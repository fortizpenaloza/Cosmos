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
TriggerManagementSystemUserStoryTest >> septemberSixth2015AtTwelveOFivePM [

	^ (September sixth , 2015) atNoon next: self fiveMinutes
]

{ #category : #accessing }
TriggerManagementSystemUserStoryTest >> setTriggeredToTrue [

	^ Action
		named: 'Set triggered to true'
		evaluating: (EvaluateBlockPolicy for: [ triggered := true ])
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

	trigger := self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: self setTriggeredToTrue
		periodicallyEvery: self fiveMinutes
		ifSatisfies: AlwaysTriggeringCondition new.

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

	trigger := self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		afterDataPointWasRegisteredOn: dataStream
		ifSatisfies: AlwaysTriggeringCondition new.

	self
		assert: self triggerManagementSystem triggers
		hasTheSameElementsInTheSameOrderThat: {trigger}.

	self triggerManagementSystem
		deregisterNamed: 'Set triggered to true after data point registration'.

	self assert: self triggerManagementSystem triggers isEmpty
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testRegistrationFailsIfTriggerWithSameNameAlreadyRegistered [

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: self setTriggeredToTrue
		periodicallyEvery: self fiveMinutes
		ifSatisfies: AlwaysTriggeringCondition new.

	self
		should: [ self triggerManagementSystem
				registerNamed: 'Set triggered to true every 5 minutes'
				triggering: self setTriggeredToTrue
				periodicallyEvery: self tenMinutes
				ifSatisfies: AlwaysTriggeringCondition new ]
		raise: ConflictingObjectFound
		whoseDescriptionIncludes: 'Trigger with that name already exists in system'
		description: 'Expected: Trigger with that name already exists in system'
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testRegistrationToBePeriodicallyTriggered [

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: self setTriggeredToTrue
		periodicallyEvery: self fiveMinutes
		ifSatisfies: AlwaysTriggeringCondition new.

	self withTheOnlyOneIn: self triggerManagementSystem triggers do: [:trigger | 
		self assert: trigger name equals: 'Set triggered to true every 5 minutes' ]
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testRegistrationToBeTriggeredOnDataPointRegistration [

	| dataStream |

	dataStream := self temperatureStream.

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		afterDataPointWasRegisteredOn: dataStream
		ifSatisfies: AlwaysTriggeringCondition new.

	self withTheOnlyOneIn: self triggerManagementSystem triggers do: [:trigger | 
		self assert: trigger name equals: 'Set triggered to true after data point registration' ]
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testTriggerOnDataPointRegistrationWhenSatisfiesDataStreamCurrentValueCondition [

	| dataStream |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		afterDataPointWasRegisteredOn: dataStream
		ifSatisfies: (DataStreamCurrentValueTriggeringCondition of: dataStream isLessThan: 11).

	self deny: triggered.
	self dataManagementSystem register: (DataPoint on: self systemDateTime holding: 12) toStreamNamed: dataStream name.
	self deny: triggered.
	self dataManagementSystem register: (DataPoint on: self systemDateTime holding: 10) toStreamNamed: dataStream name.
	self assert: triggered
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testTriggerPeriodicallyEveryTenMinutes [

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering:  self setTriggeredToTrue
		periodicallyEvery: self tenMinutes 
		ifSatisfies: AlwaysTriggeringCondition new.
	
	self deny: triggered.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self fiveMinutes).

	self deny: triggered.
	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self tenMinutes).
		
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

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 10 minutes'
		triggering: self setTriggeredToTrue
		periodicallyEvery: self tenMinutes
		ifSatisfies: condition.

	self deny: triggered.

	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 12)
		toStreamNamed: dataStream name.
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self fiveMinutes).
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self tenMinutes).
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self tenMinutes).
	self assert: triggered
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testTriggerPeriodicallyEveryTenMinutesWhenSatisfiesDataStreamCurrentValueDuringATimeInterval [

	| dataStream condition |

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	condition := AndCompositeTriggeringCondition
		with: (DataStreamCurrentValueTriggeringCondition of: dataStream isLessThan: 11)
		with:
			(TimeIntervalTriggeringCondition
				checkingCurrentTimeIsBetween: (self eightPM to: self ninePM)).

	self triggerManagementSystem
		registerNamed: 'Set triggered to true every 5 minutes'
		triggering: self setTriggeredToTrue
		periodicallyEvery: self tenMinutes
		ifSatisfies: condition.

	self deny: triggered.

	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 10)
		toStreamNamed: dataStream name.
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.

	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 12)
		toStreamNamed: dataStream name.
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.

	timeSource setTimeTo: self eightPM.
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.

	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 10)
		toStreamNamed: dataStream name.
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self tenMinutes).
	self assert: triggered
]

{ #category : #tests }
TriggerManagementSystemUserStoryTest >> testTriggeringOnDataPointRegistration [

	| dataStream |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:.

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		afterDataPointWasRegisteredOn: dataStream
		ifSatisfies: AlwaysTriggeringCondition new.

	self deny: triggered.
	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 12)
		toStreamNamed: dataStream name.
	self assert: triggered
]
