"
I'm TriggerSystem, a system that manages triggers related to feeds.

My main responsability is to manage triggers and evaluate them when a condition matches.


"
Class {
	#name : #TriggerManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'triggersToTriggerPeriodically',
		'triggersToTriggerAfterDataPointRegistration',
		'actionTriggers',
		'pendingActionsQueue'
	],
	#category : #'Cosmos-Triggers-SystemModel'
}

{ #category : #'instance creation' }
TriggerManagementSystem class >> enqueuingActionsInto: aPendingActionsQueue [
		
	^ self new initializeEnqueuingActionsInto: aPendingActionsQueue 
]

{ #category : #installing }
TriggerManagementSystem >> dependencies [

	^ #(#TimeSystemInterface #EventNotificationSystemInterface #TimestampingSystemInterface #IdentifierSystemInterface)
]

{ #category : #managing }
TriggerManagementSystem >> deregister: anActionTrigger [

	self deregister: anActionTrigger accordingTo: anActionTrigger triggeringPolicy
]

{ #category : #'private - managing' }
TriggerManagementSystem >> deregister: anActionTrigger accordingTo: aTriggeringPolicy [ 

	aTriggeringPolicy deregister: anActionTrigger from: self.
	actionTriggers remove: anActionTrigger
]

{ #category : #'private - managing' }
TriggerManagementSystem >> deregister: anActionTrigger fromTriggeredPeriodicallyEvery: aTimePeriod [ 

	(self triggersToTriggerPeriodicallyEvery: aTimePeriod) remove: anActionTrigger 
]

{ #category : #'private - managing' }
TriggerManagementSystem >> deregister: anActionTrigger toStopTriggeringAfterDataPointRegistrationOn: aDataStream [ 
	
	(self triggersToTriggerAfterDataPointRegistrationOn: aDataStream) remove: anActionTrigger 	
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

{ #category : #'private - events handling' }
TriggerManagementSystem >> enqueue: anAction [

	pendingActionsQueue enqueue: anAction
	
]

{ #category : #'private - systems' }
TriggerManagementSystem >> eventNotificationSystem [
	
	^ self >> #EventNotificationSystemInterface
]

{ #category : #'events handling' }
TriggerManagementSystem >> handleDataPointRegistrationOn: anEvent [

	self
		do: [ :action | self enqueue: action ]
		withSatisfiedTriggersWithin: self triggeringContext
		afterDataPointWasRegisteredOn: anEvent dataStream
]

{ #category : #'events handling' }
TriggerManagementSystem >> handleTickOn: anEvent [

	self
		do: [ :action | self enqueue: action ]
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
TriggerManagementSystem >> initializeEnqueuingActionsInto: aPendingActionsQueue [ 
	
	self initialize.
	pendingActionsQueue := aPendingActionsQueue.
	
	actionTriggers := OrderedCollection new.
	triggersToTriggerAfterDataPointRegistration := Dictionary new.
	triggersToTriggerPeriodically := Dictionary new
]

{ #category : #accessing }
TriggerManagementSystem >> name [ 

	^ 'Trigger Management'
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
TriggerManagementSystem >> register: anActionTrigger accordingTo: aTriggeringPolicy [

	actionTriggers add: anActionTrigger.
	aTriggeringPolicy register: anActionTrigger to: self.

	self registerIdentifierFor: anActionTrigger.
	self registerTimestampFor: anActionTrigger
]

{ #category : #'private - managing' }
TriggerManagementSystem >> register: anActionTrigger toTriggerAfterDataPointRegistrationOn: aDataStream [

	triggersToTriggerAfterDataPointRegistration 
		at: aDataStream 
		ifPresent: [ :registeredTriggers | registeredTriggers add: anActionTrigger ] 
		ifAbsentPut: [ OrderedCollection with: anActionTrigger ] 
]

{ #category : #'private - managing' }
TriggerManagementSystem >> register: anActionTrigger toTriggerPeriodicallyEvery: aTimePeriod [

	triggersToTriggerPeriodically
		at: aTimePeriod
		ifPresent: [ :registeredTriggers | registeredTriggers add: anActionTrigger ]
		ifAbsentPut: [ OrderedCollection with: anActionTrigger ]
]

{ #category : #'private - managing' }
TriggerManagementSystem >> registerIdentifierFor: anActionTrigger [ 

	self identifierSystem registerIdentifierFor: anActionTrigger
]

{ #category : #'private - managing' }
TriggerManagementSystem >> registerTimestampFor: anActionTrigger [

	self timestampingSystem registerModificationFor: anActionTrigger
]

{ #category : #'private - controlling' }
TriggerManagementSystem >> startUpWhenStopped [

	super startUpWhenStopped.

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
		ifNone: [ ObjectNotFound signal: 'Action trigger with that identifier not found' ]
]

{ #category : #'private - querying' }
TriggerManagementSystem >> triggerNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock [

	^ actionTriggers
		detect: [ :actionTrigger | actionTrigger name = aName ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #'private - accessing' }
TriggerManagementSystem >> triggeringContext [
	
	^ TriggeringContext providing: self timeSystem dateTime
]

{ #category : #querying }
TriggerManagementSystem >> triggers [

	^ actionTriggers copy
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
