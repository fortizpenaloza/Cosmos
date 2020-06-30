Class {
	#name : #CosmosUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'triggered',
		'timeSource',
		'pendingActionsQueue',
		'actionEvaluationsQueue'
	],
	#category : #'Cosmos-UserStoryTests'
}

{ #category : #'private - systems' }
CosmosUserStoryTest >> actionEvaluationSystem [
	
	^ rootSystem >> #ActionEvaluationSystemInterface
]

{ #category : #tests }
CosmosUserStoryTest >> assertActionWasEvaluated [

	self
		assert: triggered;
		assert: pendingActionsQueue isEmpty;
		deny: actionEvaluationsQueue isEmpty.

	(Delay forDuration: 10 milliSeconds) wait.

	self
		assert: triggered;
		assert: pendingActionsQueue isEmpty;
		assert: actionEvaluationsQueue isEmpty.

	self
		withTheOnlyOneIn: self actionEvaluationSystem actionEvaluations
		do:
			[ :actionEvaluation | self assert: actionEvaluation action equals: self setTriggeredToTrue ]
]

{ #category : #tests }
CosmosUserStoryTest >> assertPendingActionIsEmpty [

	self
		assert: pendingActionsQueue isEmpty.
	self deny: triggered
]

{ #category : #tests }
CosmosUserStoryTest >> assertPendingActionsNotEmpty [

	self
		deny: triggered;
		deny: pendingActionsQueue isEmpty;
		assert: pendingActionsQueue size equals: 1
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> eightPM [
	
	^ TimeOfDay hours: 20
]

{ #category : #'private - action evaluation' }
CosmosUserStoryTest >> evaluate [

	| nextAction |

	nextAction := pendingActionsQueue dequeue.
	nextAction evaluateWithin: self.
	actionEvaluationsQueue
		enqueue: (ActionEvaluation of: nextAction on: self systemDateTime)
]

{ #category : #'private - systems' }
CosmosUserStoryTest >> eventNotificationSystem [

	^ rootSystem >> #EventNotificationSystemInterface
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> ninePM [
	
	^ TimeOfDay hours: 21
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> octoberFirstOf2014AtNoon [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> oneMinute [

	^ TimeUnits minute with: 1
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> setTriggeredToTrue [

	^ Action
		named: 'Set triggered to true'
		evaluating: [ triggered := true ]
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> setTriggeredToTrueAfterDataPointRegistrationOn: aDataStream [

	^ ActionTrigger
		named: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: aDataStream)
		ifSatisfies: AlwaysTriggeringCondition new
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> setTriggeredToTrueEvery: aTimePeriod [

	^ self setTriggeredToTrueEvery: aTimePeriod ifSatisfies: AlwaysTriggeringCondition new
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> setTriggeredToTrueEvery: aTimePeriod ifSatisfies: aCondition [

	^ ActionTrigger
		named: ('Set triggered to true every <1p>' expandMacrosWith: aTimePeriod)
		triggering: self setTriggeredToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: aTimePeriod)
		ifSatisfies: aCondition
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> setTriggeredToTrueEveryFiveMinutes [

	^ self setTriggeredToTrueEvery: self fiveMinutes
]

{ #category : #running }
CosmosUserStoryTest >> setUp [
	
	pendingActionsQueue := AtomicSharedQueue new.
	actionEvaluationsQueue := AtomicSharedQueue new.
	super setUp. 
	triggered := false.
]

{ #category : #running }
CosmosUserStoryTest >> setUpRequirements [

	timeSource := FixedTimeSource on: self systemDateTime.

	self
		registerSubsystem: (TimeSystem using: timeSource);
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: DataStreamManagementSystem new;
		registerSubsystem: ActionManagementSystem new;
		registerSubsystem: (ActionEvaluationSystem registeringFrom: actionEvaluationsQueue);
		registerSubsystem: (TriggerManagementSystem enqueuingActionsInto: pendingActionsQueue)
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> systemDateTime [
	
	^ self octoberFirstOf2014AtNoon 
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> temperatureStream [

	^ DataStream named: 'Temperature'
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> tenMinutes [

	^ TimeUnits minute with: 10
]

{ #category : #tests }
CosmosUserStoryTest >> testTriggerOnDataPointRegistrationWhenSatisfiesCompositeDataStreamCurrentValueCondition [

	| temperature isCoolingOn trigger |

	temperature := self temperatureStream.
	self dataManagementSystem register: temperature.
	isCoolingOn := DataStream named: 'is_cooling_on'.
	self dataManagementSystem register: isCoolingOn.

	self dataManagementSystem  register: ( DataPoint on: self systemDateTime holding: 23 ) to: temperature.
	self dataManagementSystem register: ( DataPoint on: self systemDateTime holding: triggered asBit ) to: isCoolingOn.

	trigger := ActionTrigger
		named: 'Set triggered to true when temperature is higher than 24'
		triggering: self setTriggeredToTrue
		accordingTo: ( DataPointRegistrationTriggeringPolicy on: temperature )
		ifSatisfies:
			( AndCompositeTriggeringCondition
				with: ( DataStreamCurrentValueTriggeringCondition of: temperature isGreaterThan: 24 )
				with: ( DataStreamCurrentValueTriggeringCondition of: isCoolingOn isEqualTo: 0 ) ).
	self triggerManagementSystem register: trigger.

	self assertPendingActionIsEmpty.

	self dataManagementSystem register: ( DataPoint on: self systemDateTime holding: 24 ) to: temperature.
	self dataManagementSystem register: ( DataPoint on: self systemDateTime holding: triggered asBit ) to: isCoolingOn.
	self assertPendingActionIsEmpty.
	self dataManagementSystem  register: ( DataPoint on: self systemDateTime holding: 25 ) to: temperature.
	self dataManagementSystem register: ( DataPoint on: self systemDateTime holding: triggered asBit ) to: isCoolingOn.

	self assertPendingActionsNotEmpty.
	self evaluate.
	self assertActionWasEvaluated.

	self dataManagementSystem  register: ( DataPoint on: self systemDateTime holding: 26 ) to: temperature.
	self dataManagementSystem  register: ( DataPoint on: self systemDateTime holding: triggered asBit ) to: isCoolingOn.

	self
		assert: triggered;
		deny: pendingActionsQueue isEmpty;
		assert: pendingActionsQueue size equals: 1.
		
	self evaluate.

	self dataManagementSystem  register: ( DataPoint on: self systemDateTime holding: 27 ) to: temperature.
	self dataManagementSystem  register: ( DataPoint on: self systemDateTime holding: triggered asBit ) to: isCoolingOn.

	self assert: pendingActionsQueue isEmpty
]

{ #category : #tests }
CosmosUserStoryTest >> testTriggerOnDataPointRegistrationWhenSatisfiesDataStreamCurrentValueCondition [

	| dataStream trigger |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.
	trigger := ActionTrigger
		named: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		accordingTo: ( DataPointRegistrationTriggeringPolicy on: dataStream )
		ifSatisfies: ( DataStreamCurrentValueTriggeringCondition of: dataStream isLessThan: 11 ).
	self triggerManagementSystem register: trigger.
	self
		deny: triggered;
		assert: pendingActionsQueue isEmpty.
	self dataManagementSystem
		register: ( DataPoint on: self systemDateTime holding: 12 )
		to: dataStream.
	self
		deny: triggered;
		assert: pendingActionsQueue isEmpty.
	self dataManagementSystem
		register: ( DataPoint on: self systemDateTime holding: 10 )
		to: dataStream.
	self
		deny: triggered;
		deny: pendingActionsQueue isEmpty.

	self evaluate.
	self assertActionWasEvaluated
]

{ #category : #tests }
CosmosUserStoryTest >> testTriggerPeriodicallyEveryTenMinutes [

	self triggerManagementSystem register: self setTriggeredToTrueEveryFiveMinutes.
	self
		deny: triggered;
		assert: pendingActionsQueue isEmpty.

	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self oneMinute).
	self
		deny: triggered;
		assert: pendingActionsQueue isEmpty.

	self eventNotificationSystem
		notifySubscribersTo: (TickEvent of: self fiveMinutes).	
	self
		deny: triggered;
		deny: pendingActionsQueue isEmpty.
	
	self evaluate.
	self assertActionWasEvaluated
]

{ #category : #tests }
CosmosUserStoryTest >> testTriggerPeriodicallyEveryTenMinutesIfDataStreamHasNotBeenUpdated [

	| dataStream condition |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		checkingIf: dataStream
		hasNotBeenUpdatedForMoreThan: self fiveMinutes.

 	self triggerManagementSystem register: (self setTriggeredToTrueEvery: self tenMinutes ifSatisfies: condition).
	self deny: triggered.

	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 12)
		to: dataStream.
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self fiveMinutes).
	self deny: triggered.

	timeSource setTimeTo: (timeSource dateTime timeOfDay next: self fiveMinutes).
	self eventNotificationSystem notifySubscribersTo: (TickEvent of: self tenMinutes).
	self deny: triggered.
	

	self evaluate.
	self assertActionWasEvaluated
]

{ #category : #tests }
CosmosUserStoryTest >> testTriggerPeriodicallyEveryTenMinutesWhenSatisfiesDataStreamCurrentValueDuringATimeInterval [

	| dataStream condition |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	condition := AndCompositeTriggeringCondition
		with: ( DataStreamCurrentValueTriggeringCondition of: dataStream isLessThan: 11 )
		with: ( TimeIntervalTriggeringCondition checkingCurrentTimeIsBetween: ( self eightPM to: self ninePM ) ).

	self triggerManagementSystem
		register: ( self setTriggeredToTrueEvery: self tenMinutes ifSatisfies: condition ).

	self deny: triggered.

	self dataManagementSystem
		register: ( DataPoint on: self systemDateTime holding: 10 )
		to: dataStream.
	self eventNotificationSystem notifySubscribersTo: ( TickEvent of: self tenMinutes ).
	self deny: triggered.

	self dataManagementSystem
		register: ( DataPoint on: self systemDateTime holding: 12 )
		to: dataStream.
	self eventNotificationSystem notifySubscribersTo: ( TickEvent of: self tenMinutes ).
	self deny: triggered.

	timeSource setTimeTo: self eightPM.
	self eventNotificationSystem notifySubscribersTo: ( TickEvent of: self tenMinutes ).
	self deny: triggered.

	self dataManagementSystem
		register: ( DataPoint on: self systemDateTime holding: 10 )
		to: dataStream.
	self eventNotificationSystem notifySubscribersTo: ( TickEvent of: self tenMinutes ).
	self deny: triggered.

	self evaluate.
	self assertActionWasEvaluated
]

{ #category : #tests }
CosmosUserStoryTest >> testTriggeringOnDataPointRegistration [

	| dataStream |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	self triggerManagementSystem
		register: (self setTriggeredToTrueAfterDataPointRegistrationOn: dataStream).

	self deny: triggered.
	self dataManagementSystem
		register: (DataPoint on: self systemDateTime holding: 12)
		to: dataStream.
	self deny: triggered.
	
	self evaluate.
	self assertActionWasEvaluated
]
