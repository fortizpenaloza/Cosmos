Class {
	#name : #CosmosUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'triggered',
		'timeSource'
	],
	#category : #'Cosmos-Tests'
}

{ #category : #'private - accessing' }
CosmosUserStoryTest >> eightPM [
	
	^ TimeOfDay hours: 20
]

{ #category : #'action evaluation' }
CosmosUserStoryTest >> evaluateActionOn: anEvaluateActionEvent [

	ActionEvaluator new evaluate: anEvaluateActionEvent action
]

{ #category : #systems }
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
		evaluating: (EvaluateBlockPolicy for: [ triggered := true ])
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
	
	super setUp. 
	triggered := false.
]

{ #category : #running }
CosmosUserStoryTest >> setUpRequirements [

	timeSource := FixedTimeSource on: self systemDateTime .

	self
		registerSubsystem: (TimeSystem using: timeSource);
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: DataStreamManagementSystem new;
		registerSubsystem: ActionManagementSystem new;
		registerSubsystem: TriggerManagementSystem new
]

{ #category : #'private - accessing' }
CosmosUserStoryTest >> suscribeToEvaluateActionEvent [

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:
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
CosmosUserStoryTest >> testTriggerOnDataPointRegistrationWhenSatisfiesDataStreamCurrentValueCondition [

	| dataStream trigger |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.
	self suscribeToEvaluateActionEvent.

	trigger := ActionTrigger
		named: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: dataStream)
		ifSatisfies:
			(DataStreamCurrentValueTriggeringCondition
				of: dataStream
				isLessThan: 11).
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
CosmosUserStoryTest >> testTriggerPeriodicallyEveryTenMinutes [

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
CosmosUserStoryTest >> testTriggerPeriodicallyEveryTenMinutesIfDataStreamHasNotBeenUpdated [

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
CosmosUserStoryTest >> testTriggerPeriodicallyEveryTenMinutesWhenSatisfiesDataStreamCurrentValueDuringATimeInterval [

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
CosmosUserStoryTest >> testTriggeringOnDataPointRegistration [

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
