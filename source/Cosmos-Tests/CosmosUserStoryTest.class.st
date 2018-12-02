Class {
	#name : #CosmosUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Tests'
}

{ #category : #'action evaluation' }
CosmosUserStoryTest >> evaluateActionOn: anEvaluateActionEvent [

	ActionEvaluator new evaluate: anEvaluateActionEvent action
]

{ #category : #running }
CosmosUserStoryTest >> setUp [
	
	super setUp. 
	triggered := false.
]

{ #category : #'tests - support' }
CosmosUserStoryTest >> suscribeToEvaluateActionEvent [

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateActionOn:
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
