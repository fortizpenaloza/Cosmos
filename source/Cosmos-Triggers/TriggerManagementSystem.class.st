"
I'm TriggerSystem, a system that manages triggers related to feeds.

My main responsability is to manage triggers and evaluate them when a condition matches.


"
Class {
	#name : #TriggerManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'triggers',
		'triggersToTriggerPeriodically',
		'triggersToTriggerAfterDataPointRegistration'
	],
	#category : #'Cosmos-Triggers-SystemModel'
}

{ #category : #installing }
TriggerManagementSystem >> dependencies [

	^ #(#TimeSystemInterface #EventNotificationSystemInterface #TimestampingSystemInterface #IdentifierSystemInterface)
]

{ #category : #managing }
TriggerManagementSystem >> deregister: anActionTrigger [

	self deregister: anActionTrigger accordingTo: anActionTrigger triggeringPolicy
]

{ #category : #'private - managing' }
TriggerManagementSystem >> deregister: aTrigger accordingTo: aTriggeringPolicy [ 

	aTriggeringPolicy deregister: aTrigger from: self.
	triggers remove: aTrigger
]

{ #category : #'private - managing' }
TriggerManagementSystem >> deregister: aTrigger fromTriggeredPeriodicallyEvery: aTimePeriod [ 

	(self triggersToTriggerPeriodicallyEvery: aTimePeriod) remove: aTrigger 
]

{ #category : #'private - managing' }
TriggerManagementSystem >> deregister: aTrigger toStopTriggeringAfterDataPointRegistrationOn: aDataStream [ 
	
	(self triggersToTriggerAfterDataPointRegistrationOn: aDataStream) remove: aTrigger 	
]

{ #category : #'private - events handling' }
TriggerManagementSystem >> do: aBlock withSatisfiedTriggersWithin: aTriggeringContext afterDataPointWasRegisteredOn: aDataStream [

	(self triggersToTriggerAfterDataPointRegistrationOn: aDataStream)
		do:
			[ :actionTrigger | actionTrigger do: aBlock ifSatisfiedWithin: aTriggeringContext ]
]

{ #category : #'private - events handling' }
TriggerManagementSystem >> do: aBlock withSatisfiedTriggersWithin: aTriggeringContext havingPassed: aTimePeriod [

	(self triggersToTriggerPeriodicallyEvery: aTimePeriod)
		do:
			[ :actionTrigger | actionTrigger do: aBlock ifSatisfiedWithin: aTriggeringContext ]
]

{ #category : #'private - systems' }
TriggerManagementSystem >> eventNotificationSystem [
	
	^ self >> #EventNotificationSystemInterface
]

{ #category : #'events handling' }
TriggerManagementSystem >> handleDataPointRegistrationOn: anEvent [

	self
		do: [ :action | self notifyEvaluationOf: action ]
		withSatisfiedTriggersWithin: self triggeringContext
		afterDataPointWasRegisteredOn: anEvent dataStream
]

{ #category : #'events handling' }
TriggerManagementSystem >> handleTickOn: anEvent [

	self
		do: [ :action | self notifyEvaluationOf: action ]
		withSatisfiedTriggersWithin: self triggeringContext
		havingPassed: anEvent timePeriod
]

{ #category : #'private - systems' }
TriggerManagementSystem >> identifierSystem [
	
	^ self >> #IdentifierSystemInterface
]

{ #category : #installing }
TriggerManagementSystem >> implementedInterfaces [

	^ #(#TriggerManagementSystemInterface)
]

{ #category : #initialization }
TriggerManagementSystem >> initialize [

	super initialize.
	triggers := OrderedCollection new.
	
	triggersToTriggerAfterDataPointRegistration := Dictionary new.
	triggersToTriggerPeriodically := Dictionary new
]

{ #category : #accessing }
TriggerManagementSystem >> name [ 

	^ 'Trigger Management'
]

{ #category : #'private - events handling' }
TriggerManagementSystem >> notifyEvaluationOf: anAction [

	self eventNotificationSystem notifySubscribersTo: (EvaluateActionEvent of: anAction)
	
]

{ #category : #managing }
TriggerManagementSystem >> register: anActionTrigger [

	self
		triggerNamed: anActionTrigger name
		ifFound: [ :trigger | 
			ConflictingObjectFound
				signal: 'Trigger with that name already exists in system' ]
		ifNone: [ self
				register: anActionTrigger
				accordingTo: anActionTrigger triggeringPolicy ]
]

{ #category : #'private - managing' }
TriggerManagementSystem >> register: aTrigger accordingTo: aTriggeringPolicy [

	triggers add: aTrigger.
	aTriggeringPolicy register: aTrigger to: self.

	self registerIdentifierFor: aTrigger.
	self registerTimestampFor: aTrigger
]

{ #category : #'private - managing' }
TriggerManagementSystem >> register: aTrigger toTriggerAfterDataPointRegistrationOn: aDataStream [

	triggersToTriggerAfterDataPointRegistration 
		at: aDataStream 
		ifPresent: [ :registeredTriggers | registeredTriggers add: aTrigger ] 
		ifAbsentPut: (OrderedCollection with: aTrigger)
]

{ #category : #'private - managing' }
TriggerManagementSystem >> register: aTrigger toTriggerPeriodicallyEvery: aTimePeriod [

	triggersToTriggerPeriodically
		at: aTimePeriod
		ifPresent: [ :registeredTriggers | registeredTriggers add: aTrigger ]
		ifAbsentPut: (OrderedCollection with: aTrigger)
]

{ #category : #'private - managing' }
TriggerManagementSystem >> registerIdentifierFor: anActionTrigger [ 

	self identifierSystem registerIdentifierFor: anActionTrigger
]

{ #category : #'private - managing' }
TriggerManagementSystem >> registerTimestampFor: anActionTrigger [

	self timestampingSystem registerModificationFor: anActionTrigger
]

{ #category : #'starting - stopping' }
TriggerManagementSystem >> startUp [

	super startUp.
	
	self subscribeToDataPointRegistrationEvents.
	self subscribeToTickEvents
]

{ #category : #'private - events handling' }
TriggerManagementSystem >> subscribeToDataPointRegistrationEvents [

	self eventNotificationSystem
		subscribe: self
		to: DataPointRegistrationEvent
		toBeNotifiedSending: #handleDataPointRegistrationOn:
]

{ #category : #'private - events handling' }
TriggerManagementSystem >> subscribeToTickEvents [

	self eventNotificationSystem
		subscribe: self
		to: TickEvent
		toBeNotifiedSending: #handleTickOn:
]

{ #category : #'private - systems' }
TriggerManagementSystem >> timeSystem [

	^ self >> #TimeSystemInterface
]

{ #category : #'private - systems' }
TriggerManagementSystem >> timestampingSystem [

	^ self >> #TimestampingSystemInterface
]

{ #category : #querying }
TriggerManagementSystem >> triggerIdentifiedBy: anIdentifier [

	^ self identifierSystem
		objectIdentifiedBy: anIdentifier
		ifNone: [ ObjectNotFound signal: 'Trigger with that identifier not found' ]
]

{ #category : #'private - querying' }
TriggerManagementSystem >> triggerNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock [

	^ triggers
		detect: [ :trigger | trigger name = aName ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #'private - accessing' }
TriggerManagementSystem >> triggeringContext [
	
	^ TriggeringContext providing: self timeSystem dateTime
]

{ #category : #querying }
TriggerManagementSystem >> triggers [

	^ triggers copy
]

{ #category : #'private - querying' }
TriggerManagementSystem >> triggersToTriggerAfterDataPointRegistrationOn: aDataStream [

	^ triggersToTriggerAfterDataPointRegistration
		at: aDataStream
		ifAbsent: [ #() ]
]

{ #category : #'private - querying' }
TriggerManagementSystem >> triggersToTriggerPeriodicallyEvery: aTimePeriod [

	^ triggersToTriggerPeriodically
		at: aTimePeriod 
		ifAbsent: [ #() ]
]
